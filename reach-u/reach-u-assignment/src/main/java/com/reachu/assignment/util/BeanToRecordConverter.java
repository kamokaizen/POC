package com.reachu.assignment.util;

import org.apache.avro.Schema;
        import org.apache.avro.generic.GenericData;
        import org.apache.avro.generic.GenericRecord;
        import org.apache.avro.reflect.ReflectData;

        import java.util.ArrayList;
        import java.util.List;

/**
 * Created by kamilinal on 12/18/18.
 */
public class BeanToRecordConverter<E> {
    private final PropertyExtractors extractors = new PropertyExtractors();

    private final Class<?> type;
    private final Schema schema;

    public BeanToRecordConverter(Class<E> type) {
        this.type = type;
        this.schema = ReflectData.get().getSchema(type);
    }

    public BeanToRecordConverter(Class<E> type, Schema schema) {
        this.type = type;
        this.schema = schema;
    }

    public GenericRecord convert(E bean) {
        try {
            return convertBeanToRecord(bean, schema);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private GenericRecord convertBeanToRecord(Object bean, Schema schema) throws Exception {
        Class<?> beanClass = bean.getClass();
        PropertyExtractors.PropertyExtractor extractor = extractors.getOrCreate(beanClass);

        GenericRecord result = new GenericData.Record(schema);

        List<Schema.Field> fields = schema.getFields();

        for (Schema.Field field : fields) {
            Schema fieldSchema = field.schema();

            Schema.Type type = fieldSchema.getType();
            String name = field.name();
            Object value = extractor.extract(bean, name);

            if (isSimpleType(type)) {
                result.put(name, value);
                continue;
            }

            if (type.equals(Schema.Type.RECORD)) {
                GenericRecord fieldRes = convertBeanToRecord(value, fieldSchema);
                result.put(name, fieldRes);
                continue;
            }

            if (type.equals(Schema.Type.ARRAY)) {
                // let's assume it's always list
                List<Object> elements = (List<Object>) value;
                Schema elementSchema = fieldSchema.getElementType();

                if (isSimpleType(elementSchema.getType())) {
                    result.put(name, elements);
                    continue;
                }

                List<GenericRecord> results = new ArrayList<>(elements.size());

                for (Object element : elements) {
                    GenericRecord elementRes = convertBeanToRecord(element, elementSchema);
                    results.add(elementRes);
                }

                result.put(name, results);
                continue;
            }
        }

        return result;
    }

    public static boolean isSimpleType(Schema.Type type) {
        if (type.equals(Schema.Type.STRING)) {
            return true;
        }
        if (type.equals(Schema.Type.INT)) {
            return true;
        }
        if (type.equals(Schema.Type.LONG)) {
            return true;
        }
        if(type.equals(Schema.Type.FLOAT)) {
            return true;
        }
        if(type.equals(Schema.Type.DOUBLE)){
            return true;
        }

        return false;
    }

}