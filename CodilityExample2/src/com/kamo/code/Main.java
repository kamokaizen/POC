package com.kamo.code;

import java.util.Random;

import static com.sun.org.apache.xalan.internal.xsltc.compiler.util.Type.Int;

public class Main {

    public static void main(String[] args) {
	// write your code here
        int length = 99999;

        int[] A = new int[length];
        int[] B = new int[length];


        Random rn = new Random();
        int aMax = 1000;
        int aMin = 0;

        int bMax = 999999;
        int bMin = 0;

        for(int i=0;i<length;i++){

            int rangeA = aMax - aMin + 1;
            int randomNumA =  rn.nextInt(rangeA) + aMin;
            int rangeB = bMax - bMin + 1;
            int randomNumB =  rn.nextInt(rangeB) + bMin;

            A[i] = randomNumA;
            B[i] = randomNumB;
        }

        int solution = solution(A, B);
        System.out.println("Solution : " + solution);
    }

    public static int solution(int[] A, int[] B) {
        // write your code in Java SE 8
        double[] C = new double[A.length];
        int multiplicativeCount = 0;

        // create C array
        for(int i=0;i<A.length;i++){
            C[i] = Double.valueOf(A[i]) + (Double.valueOf(B[i]) / Double.valueOf(1000000));
        }

        int p=0;
        int q=0;
        int n=C.length;

        for(int i=0;i<C.length;i++){
            q=p+1;
            while(q<n){
                // calculate multiplication
                double multiplication = C[p] * C[q];
                // calculate sum
                double sum = C[p] + C[q];

                // check the multiplication greater or equal then increment counter
                if(multiplication >= sum){
                    // System.out.println("Multiplication: ("+ p + "," + q + ")" + " Multiplication:" + multiplication + " | Sum: "+ sum);
                    multiplicativeCount++;
                }
                q++;
            }
            p++;
        }


        if(multiplicativeCount> 1000000000){
            return 1000000000;
        }
        else{
            return multiplicativeCount;
        }
    }
}
