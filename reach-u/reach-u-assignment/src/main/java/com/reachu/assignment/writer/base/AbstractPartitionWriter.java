package com.reachu.assignment.writer.base;
import com.reachu.assignment.dto.parquet.BaseParquetDTO;
import com.reachu.assignment.util.PartitionUtil;
import com.reachu.assignment.writer.ParquetWriterHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kamili on 19/12/2018.
 */
@Configuration
public abstract class AbstractPartitionWriter<E extends BaseParquetDTO> {
    protected final Logger LOGGER = LoggerFactory.getLogger(AbstractPartitionWriter.class);

    protected ParquetWriterHelper<E> writer;

    @Value("${partition.path}")
    protected String partitionsPath;

    @Autowired
    protected PartitionUtil partitionUtil;

    public AbstractPartitionWriter() {
        this.writer = new ParquetWriterHelper(getClassOfChild());
    }

    protected void writeData(E record){
        partitionUtil.createPartitionFiles();
        try{
            List list = new ArrayList<E>();
            list.add(record);
            LOGGER.info("Parquet Data Received: {}", record.getTimestamp());
            writer.write(list, partitionUtil.getPartitionFilePath(record.getTimestamp()));
        }
        catch(Exception e){
            LOGGER.error("Something went wrong while write record:{}", e.getLocalizedMessage());
            e.printStackTrace();
        }
    }

    protected abstract Class<E> getClassOfChild();
}
