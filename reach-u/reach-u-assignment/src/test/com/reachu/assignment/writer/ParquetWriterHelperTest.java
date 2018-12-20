package com.reachu.assignment.writer;

import com.reachu.assignment.dto.parquet.SampleParquetDTO1;
import com.reachu.assignment.util.PartitionUtil;
import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest
@FixMethodOrder(MethodSorters.NAME_ASCENDING) //Running test cases in order of method names in ascending order
public class ParquetWriterHelperTest {

    private ParquetWriterHelper<SampleParquetDTO1> parquetWriterHelper = new ParquetWriterHelper<>(SampleParquetDTO1.class);

    @Autowired
    PartitionUtil partitionUtil;

    private SampleParquetDTO1 record;
    private String filePath;

    @Before
    public void initObjects() {
        record = new SampleParquetDTO1(1545334419, "kamo", 10, 10f,20.0,20, true);
        filePath = partitionUtil.getPartitionsPath() + "/test/" + record.getTimestamp() + ".parquet";
    }

    @Test
    public void test1() throws Exception {
        assertThat(parquetWriterHelper).isNotNull();
    }

    @Test
    public void test2() throws Exception {
        List list = new ArrayList<SampleParquetDTO1>();
        list.add(record);
        parquetWriterHelper.write(list, filePath);
        assertThat(new File(filePath).exists());
    }

    @Test
    public void test3()  throws Exception {
        List<SampleParquetDTO1> parquets = parquetWriterHelper.read(filePath, SampleParquetDTO1.class);
        assertThat(parquets).isNotNull();
        assertThat(parquets.get(0).getStrField() == record.getStrField());
        assertThat(parquets.get(0).getDoubleField() == record.getDoubleField());
        assertThat(parquets.get(0).getIntField() == record.getIntField());
        assertThat(parquets.get(0).getLongField() == record.getLongField());
        assertThat(parquets.get(0).isBooleanField() == record.isBooleanField());
    }
}