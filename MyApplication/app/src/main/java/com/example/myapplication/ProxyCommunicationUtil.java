package com.example.myapplication;

import android.util.Base64;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

//import org.apache.commons.codec.binary.Base64;

public class ProxyCommunicationUtil {

    public static String decryptData(int keyVersion, String data) throws ApiException {

        if (keyVersion == 1) {
            return performDecryptionV1(data);
        }

        return "";
    }

    public static String encryptData(int keyVersion, String data) throws ApiException {

        System.out.println("** 1. data : " + data);

        if (keyVersion == 1) {
            return performEncryptionV1(data);
        }

        return "";
    }

    private static String performEncryptionV1(String data) throws ApiException {

        if (data == null) {
            throw new ApiException(1, "parameter is null");
        }

        System.out.println("inside funtion. data : " + data);

        try {
            Cipher c = ProxyKeyManagementUtil.getProxyCipher_enc_mode();
            byte[] b = c.doFinal(data.getBytes());
            System.out.println("Byte length : " + b.length);
            // return Base64.encodeToString(b,16);


            StringBuilder sb = new StringBuilder();
            for (byte bb : b) {
                sb.append(String.format("%02X ", bb));
            }
            System.out.println("Hex String "+ sb.toString());

            return Base64.encodeToString(b,Base64.NO_CLOSE);
            // return "" ;
        } catch (InvalidKeyException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (NoSuchAlgorithmException e) {
            throw new ApiException(1, e.toString());
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (InvalidKeySpecException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (BadPaddingException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        }
    }

    private static String performDecryptionV1(String data) throws ApiException {

        if (data == null) {
            throw new ApiException(1, "parameter is null");
        }

        try {
            Cipher c = ProxyKeyManagementUtil.getProxyCipher_dec_mode();
            byte[] decVal = c.doFinal(Base64.decode(data, Base64.NO_CLOSE));

            if (decVal != null) {
                return new String(decVal);
            }

            return null;

        } catch (InvalidKeyException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (InvalidKeySpecException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        } catch (BadPaddingException e) {
            e.printStackTrace();
            throw new ApiException(1, e.toString());
        }
    }

}

