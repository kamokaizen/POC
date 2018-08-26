package com.kamo.code;

public class Main {

    public static void main(String[] args) {
	    // write your code here
        long start = System.currentTimeMillis();
        System.out.println("exec start:" + start);
        int xorValue = solution(1, 2);
        System.out.println("xorValue:" + xorValue);
        long end = System.currentTimeMillis();
        System.out.println("exec finish:" + end);
        System.out.println("duration:" + (end-start));
    }

    public static int solution(int M, int N){
        int tempXorValue = M;
        for(int i = M+1; i <= N; i+=1){
            // calculate XOR with new pair and temp
            // we can use ^ xor operator for get xor value
            tempXorValue = tempXorValue ^ (i);
        }
        return tempXorValue;
    }
}
