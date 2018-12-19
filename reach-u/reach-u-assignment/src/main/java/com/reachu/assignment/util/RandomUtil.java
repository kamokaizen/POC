package com.reachu.assignment.util;

import java.nio.charset.Charset;
import java.util.Random;

/**
 * Created by kamili on 19/12/2018.
 */
public class RandomUtil {

    public static String getRandomString() {
        Random random = new Random();
        byte[] array = new byte[random.nextInt(1000)];
        random.nextBytes(array);
        String generatedString = new String(array, Charset.forName("UTF-8"));
        return generatedString;
    }

    public static int getRandomInt(){
        return new Random().nextInt();
    }

    public static long getRandomLong(){
        return new Random().nextLong();
    }

    public static double getRandomDouble(){
        return new Random().nextDouble();
    }

    public static float getRandomFloat(){
        return new Random().nextFloat();
    }

    public static boolean getRandomBoolean() {
        return new Random().nextBoolean();
    }

    public static byte[] getRandomBytes() {
        Random random = new Random();
        byte[] array = new byte[random.nextInt(1000)];
        random.nextBytes(array);
        return array;
    }
}
