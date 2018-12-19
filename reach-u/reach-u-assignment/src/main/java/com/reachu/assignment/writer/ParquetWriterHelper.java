package com.reachu.assignment.writer;

import org.apache.avro.Schema;
import org.apache.avro.generic.GenericRecord;
import org.apache.avro.reflect.ReflectData;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.parquet.avro.AvroParquetWriter;
import org.apache.parquet.hadoop.ParquetWriter;
import org.apache.parquet.hadoop.metadata.CompressionCodecName;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;
import java.util.List;

/**
 * Created by kamilinal on 12/18/18.
 */
public class ParquetWriterHelper<E> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ParquetWriterHelper.class);

    private final Schema schema;
    private final BeanToRecordConverter<E> converter;

    public ParquetWriterHelper(Class<E> cls) {
        this.schema = ReflectData.get().getSchema(cls);
        this.converter = new BeanToRecordConverter<>(cls, schema);
    }

    public void write(List<E> objects, String file) {
        Path path = new Path(file);
        ParquetWriter<GenericRecord> writer = null;
        // Creating ParquetWriter using builder
        try{
            writer = AvroParquetWriter.
                    <GenericRecord>builder(path)
                    .withRowGroupSize(ParquetWriter.DEFAULT_BLOCK_SIZE)
                    .withPageSize(ParquetWriter.DEFAULT_PAGE_SIZE)
                    .withSchema(schema)
                    .withConf(new Configuration())
                    .withCompressionCodec(CompressionCodecName.SNAPPY)
                    .withValidation(false)
                    .withDictionaryEncoding(false)
                    .build();

            for (E record : objects) {
                GenericRecord rec = converter.convert(record);
                writer.write(rec);
            }
        }
        catch(Exception e){
            LOGGER.error("Parquet file write failed {}", e.getLocalizedMessage());
            e.printStackTrace();
        }
        finally {
            if(writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    LOGGER.error("Writer closed got exception {}", e.getLocalizedMessage());
                    e.printStackTrace();
                }
            }
        }
    }

}