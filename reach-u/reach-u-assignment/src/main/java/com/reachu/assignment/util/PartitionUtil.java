package com.reachu.assignment.util;

import com.reachu.assignment.queue.ParquetMessageListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by kamili on 20/12/2018.
 */
@Component
public class PartitionUtil {
    private static final Logger LOGGER = LoggerFactory.getLogger(ParquetMessageListener.class);

    @Value("${partition.time}")
    protected double partitionTime;

    @Value("${partition.path}")
    protected String partitionsPath;

    public void createPartitionFiles(){
        if(partitionTime < 1 || partitionTime > 24){
            LOGGER.error("Partition time range must be 0<range<=24, Please change partition.time in config and try again");
            return;
        }

        long currentTime = System.currentTimeMillis();
        Date currentDate = new Date(currentTime);
        Calendar cal = Calendar.getInstance();
        cal.setTime(currentDate);

        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);

        int partitionsCount = (int) Math.ceil(24.0/partitionTime); //round up

        String currentDayString = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        boolean folderCreate = this.createFolder(partitionsPath + "/" + currentDayString);

        if(folderCreate){
            for(int i=0; i<partitionsCount; i++){
                String partitionFolder = new SimpleDateFormat("yyyyMMddHHmm").format(cal.getTime());
                this.createFolder(partitionsPath + "/" + currentDayString + "/" + partitionFolder);
                cal.set(Calendar.HOUR_OF_DAY, cal.get(Calendar.HOUR_OF_DAY) + (int)partitionTime);
            }
        }
    }

    public String getPartitionFilePath(long timestamp) {
        Date currentDate = new Date(timestamp);
        Calendar cal = Calendar.getInstance();
        cal.setTime(currentDate);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);

        String currentDayString = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        int partitionsCount = (int) Math.ceil(24.0/partitionTime); //round up

        for(int i=0; i<partitionsCount; i++){
            long beginingPeriod = cal.getTime().getTime();
            String beginningPartition = new SimpleDateFormat("yyyyMMddHHmm").format(cal.getTime());
            cal.set(Calendar.HOUR_OF_DAY, cal.get(Calendar.HOUR_OF_DAY) + (int) partitionTime);
            long endPeriod = cal.getTime().getTime();

            if(timestamp <= endPeriod && timestamp >= beginingPeriod){
                return partitionsPath + "/" + currentDayString + "/" + beginningPartition + "/" + timestamp + ".parquet";
            }
        }

        // this case must not be occured
        return null;
    }

    public boolean createFile(String path){
        try {
            File file = new File(path);
            if(file.createNewFile()) {
                LOGGER.info("File creation successfully, {}", path);
                return true;
            }
            else{
                LOGGER.error("Error while creating File, file already exists in specified path, {}", path);
                return false;
            }
        }
        catch(IOException io) {
            LOGGER.error("Error while creating File , {}", io.getLocalizedMessage());
            io.printStackTrace();
            return false;
        }
        catch(Exception ex){
            LOGGER.error("Error while creating File , {}", ex.getLocalizedMessage());
            ex.printStackTrace();
            return false;
        }
    }

    public boolean createFolder(String path){
        File theDir = new File(path);

        try{
            // if the directory does not exist, create it
            if (!theDir.exists()) {
                LOGGER.info("Creating directory: " + theDir.getName());
                theDir.mkdir();
                return true;
            }
            return false;
        }
        catch(Exception er){
            LOGGER.error("Fail when creating a folder: {}", er.getLocalizedMessage());
            return false;
        }
    }
}
