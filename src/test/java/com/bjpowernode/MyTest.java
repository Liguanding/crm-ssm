package com.bjpowernode;

import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;

public class MyTest {
    @Test
    public void test01(){
        String expireTime = "2020-12-12 10:10:10";

        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String str = simpleDateFormat.format(date);
        System.out.println(str);
    }
}
