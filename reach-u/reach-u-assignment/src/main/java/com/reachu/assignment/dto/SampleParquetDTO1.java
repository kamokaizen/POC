package com.reachu.assignment.dto;

import java.util.Date;

/**
 * Created by kamilinal on 12/18/18.
 */
public class SampleParquetDTO1 extends BaseParquetDTO{
    private String strField;
    private float floatField;
    private double doubleField;

    public SampleParquetDTO1() {
        super(System.currentTimeMillis());
    }

    public SampleParquetDTO1(long timestamp, String strField, float floatField, double doubleField) {
        super(timestamp);
        this.strField = strField;
        this.floatField = floatField;
        this.doubleField = doubleField;
    }

    public String getStrField() {
        return strField;
    }

    public void setStrField(String strField) {
        this.strField = strField;
    }

    public float getFloatField() {
        return floatField;
    }

    public void setFloatField(float floatField) {
        this.floatField = floatField;
    }

    public double getDoubleField() {
        return doubleField;
    }

    public void setDoubleField(double doubleField) {
        this.doubleField = doubleField;
    }
}
