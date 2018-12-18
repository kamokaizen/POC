package com.reachu.assignment.util;

import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kamilinal on 12/18/18.
 */
public class PropertyExtractors {

    public static class PropertyExtractor {
        private final Class<?> type;
        private final Map<String, Method> getters;

        private PropertyExtractor(Class<?> type, Map<String, Method> getters) {
            this.type = type;
            this.getters = getters;
        }

        public Object extract(Object bean, String propertyName) {
            try {
                return getters.get(propertyName).invoke(bean);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

        public Class<?> getType() {
            return type;
        }
    }

    private final Map<Class<?>, PropertyExtractor> cache = new HashMap<>();

    public PropertyExtractor getOrCreate(Class<?> type) {
        if (cache.containsKey(type)) {
            return cache.get(type);
        }

        PropertyExtractor extractor = forClass(type);
        cache.put(type, extractor);
        return extractor;
    }

    public static PropertyExtractor forClass(Class<?> type) {
        try {
            return forClassNotSafe(type);
        } catch (IntrospectionException e) {
            throw new RuntimeException(e);
        }
    }

    private static PropertyExtractor forClassNotSafe(Class<?> type) throws IntrospectionException {
        BeanInfo info = Introspector.getBeanInfo(type);
        PropertyDescriptor[] properties = info.getPropertyDescriptors();

        Map<String, Method> getters = new HashMap<>();

        for (PropertyDescriptor pd : properties) {
            String name = pd.getName();
            if ("class".equals(name)) {
                continue;
            }

            Method getter = pd.getReadMethod();
            if (getter == null) {
                continue;
            }

            getters.put(name, getter);
        }

        return new PropertyExtractor(type, getters);
    }
}