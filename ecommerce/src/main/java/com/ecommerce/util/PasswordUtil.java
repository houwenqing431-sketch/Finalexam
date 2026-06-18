package com.ecommerce.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * 密码工具类 - SHA-256加盐哈希
 */
public class PasswordUtil {
    private static final int SALT_LENGTH = 16;
    private static final String SEPARATOR = ":";

    /**
     * 生成随机盐值 + 哈希密码，返回 "salt:hash" 格式
     */
    public static String hash(String plainPassword) {
        try {
            byte[] salt = new byte[SALT_LENGTH];
            new SecureRandom().nextBytes(salt);
            String saltStr = Base64.getEncoder().encodeToString(salt);
            String hashStr = sha256(saltStr + plainPassword);
            return saltStr + SEPARATOR + hashStr;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * 验证明文密码是否匹配存储的哈希值
     */
    public static boolean verify(String plainPassword, String storedHash) {
        if (storedHash == null || !storedHash.contains(SEPARATOR)) {
            return false;
        }
        String[] parts = storedHash.split(SEPARATOR, 2);
        try {
            String expected = sha256(parts[0] + plainPassword);
            return expected.equals(parts[1]);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    private static String sha256(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(input.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            hex.append(String.format("%02x", b));
        }
        return hex.toString();
    }
}
