package com.example.myapplication;

import android.support.test.InstrumentationRegistry;
import android.support.test.runner.AndroidJUnit4;

import org.junit.Test;
import org.junit.runner.RunWith;

import org.junit.Assert.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

public class PayableTest {
    @Test
    public void encryptData(){

        String sampledata = "12345678912345678" ;

        try {
            String encData = ProxyCommunicationUtil.encryptData(1, sampledata);
            System.out.println("Encrypted data : " + encData);






            String decData = ProxyCommunicationUtil.decryptData(1, encData);
            System.out.println("Decrypted data : " + decData);

            if(sampledata.equalsIgnoreCase(decData)){
                assertTrue(true) ;
                return ;
            }

        } catch (ApiException e) {
            e.printStackTrace();
        }

        assertTrue(false);

    }
}
