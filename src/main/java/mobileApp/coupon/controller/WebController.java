package mobileApp.coupon.controller;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.Headers;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import mobileApp.coupon.Coupon;
import mobileApp.coupon.dto.FileName;
import mobileApp.coupon.dto.Url;
import mobileApp.coupon.service.CouponService;
import mobileApp.coupon.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.HttpMethod;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Slf4j
@RequiredArgsConstructor
@RestController
public class WebController {
    @Autowired
    AmazonS3Client amazonS3Client;
    private final S3Uploader s3Uploader;

    @Autowired
    private CouponService couponService;

    //test용 원래 flutter에서 받아올 것
    private FileName fileName = new FileName();
    private String name;


    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Value("${cloud.aws.s3.bucket.url")
    private String objectKey;

    @GetMapping("")
    public String index() {

        return "index";
    }

    @GetMapping("hello")
    public String hello(){
        getPreSignedURL();
        return "hello";
    }

    // test용 원래는 flutter에서 받아올 예정
    @PostMapping("register/fileName")
    public FileName registerFileName(){
        fileName.setFileName("test.png");

        return fileName;
    }

    @GetMapping("register/fileName")
    public FileName getFileName( ){
        return fileName;

    }

    @PostMapping("/post/preSignedUrl")
    public Url postUrl(){
        Url preUrl = new Url();
        preUrl.setUrl(getPreSignedURL());
        return preUrl;
    }


    @PostMapping("/upload")
    public String upload(@RequestParam("data") MultipartFile multipartFile) throws IOException {
        return s3Uploader.upload(multipartFile, "test");
    }

    @GetMapping("/coupon/{user}")
    @ResponseBody
    public List<Coupon> getCouponByUser(@PathVariable String user){
        return couponService.findByUser(user);
    }


    private String getPreSignedURL() {
        String preSignedURL = "";
        //String fileName = UUID.randomUUID().toString();
        //String fileName = UUID.randomUUID().toString();
        Coupon coupon = new Coupon();

        Date expiration = new Date();
        long expTimeMillis = expiration.getTime();
        expTimeMillis += 1000 * 60 * 5;
        expiration.setTime(expTimeMillis);

        log.info(expiration.toString());

        try {

            GeneratePresignedUrlRequest generatePresignedUrlRequest =
                    new GeneratePresignedUrlRequest(bucket, this.fileName.getFileName())
                            .withMethod(HttpMethod.PUT)
                            .withExpiration(expiration);
            generatePresignedUrlRequest.addRequestParameter(
                    Headers.S3_CANNED_ACL,
                    CannedAccessControlList.PublicRead.toString());

            URL url = amazonS3Client.generatePresignedUrl(generatePresignedUrlRequest);
            preSignedURL = url.toString();
            log.info("Pre-Signed URL : " + url.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }
        //coupon.setUser("testUser");
        //coupon.setImageUrl(preSignedURL);
        //couponService.saveCoupon(coupon);

        return preSignedURL;
    }
}