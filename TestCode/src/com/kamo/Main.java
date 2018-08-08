package com.kamo;

import java.util.HashMap;
import java.util.Map;
import java.lang.*;

import static com.sun.org.apache.xalan.internal.xsltc.compiler.util.Type.Int;

public class Main {

    public static void main(String[] args) {
	    // write your code here
        int[ ] A = new int[10];
        A[0] =  0;
        A[1] =  1;
        A[2] =  3;
        A[3] = -2;
        A[4] =  0;
        A[5] =  1;
        A[6] =  0;
        A[7] = -3;
        A[8] =  2;
        A[9] =  3;
        int deepestDept = solution(A);
        System.out.println("Deepest Dept 1 = " +  deepestDept);
        deepestDept = deepest(A);
        System.out.println("Deepest Dept 2 = " +  deepestDept);
        deepestDept = deepest3(A);
        System.out.println("Deepest Dept 3 = " +  deepestDept);
    }

    public static int solution(int[ ] A){
        boolean isPitAvailable = false;
        int deepestPit = -1;

        for(int i = 0;i<A.length;i++){
            int value1 = A[i];
            for(int j=i;j<A.length;j++){
                if(j+1<A.length && j+2<A.length){
                    int value2 = (int) A[j+1];
                    int value3 = (int) A[j+2];

                    // try pit (i, i+1, i+2)
                    System.out.println("Pits = (" +  i + "," + (j+1) + "," + (j+2) + ")");
                    if(value1 > value2 && value2 < value3 && value1 < value3){
                        System.out.println("FOUND PIT = (" +  i + "," + (j+1) + "," + (j+2) + ")");
                        isPitAvailable = true;
                        int tempDeepPit = Math.min(value1-value2, value3-value2);
                        if(tempDeepPit > deepestPit){
                            deepestPit = tempDeepPit;
                        }
                    }
                }
            }
        }

        if(!isPitAvailable){
            return -1;
        }
        else{
            return deepestPit;
        }
    }

    public static int deepest3(int[] A){
        int depth = 0;

        int P = 0, Q = -1, R = -1;

        for (int i = 1; i < A.length; i++)
        {
            if (Q < 0 && A[i] >= A[i-1])
                Q = i-1;

            if ((Q >= 0 && R < 0) &&
                    (A[i] <= A[i-1] || i + 1 == A.length))
            {
                if (A[i] <= A[i-1])
                    R = i - 1;
                else
                    R = i;
                System.out.println(P+"  "+Q+"  "+R);
                depth = Math.max(depth, Math.min(A[P]-A[Q], A[R]-A[Q]));
                P = i - 1;
                Q = R = -1;
            }
        }
        if (depth == 0) depth = -1;
        System.out.println("Depth: "+depth);
        return depth;
    }

    private static int deepest(int[] data) {

        int[ ] A = new int[10];
        A[0] =  0;
        A[1] =  1;
        A[2] =  3;
        A[3] = -2;
        A[4] =  0;
        A[5] =  1;
        A[6] =  0;
        A[7] = -3;
        A[8] =  2;
        A[9] =  3;

        if (data.length < 1) {
            return 0;
        }

        int inflection = 0;
        int max = 0;
        int descent = 0;
        boolean ascending = true;
        for (int i = 1; i < data.length; i++) {
            boolean goingup = data[i] == data[i - 1] ? ascending : data[i] >= data[i - 1];
            if (goingup != ascending) {
                ascending = goingup;
                descent = ascending ? (data[inflection] - data[i - 1]) : 0;
                inflection = i - 1;
            }

            max = Math.max(max, Math.min(descent, data[i] - data[inflection]));
        }
        return max;
    }
}
