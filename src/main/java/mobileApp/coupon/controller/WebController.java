package mobileApp.coupon.controller;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.Headers;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import mobileApp.coupon.Coupon;
import mobileApp.coupon.CouponService;
import mobileApp.coupon.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.HttpMethod;
import java.io.IOException;
import java.net.URL;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Slf4j
@RequiredArgsConstructor
@Controller
public class WebController {

    @Autowired
    AmazonS3Client amazonS3Client;
    private final S3Uploader s3Uploader;

    @Autowired
    private CouponService couponService;


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


    @PostMapping("/upload")
    @ResponseBody
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
        String fileName = UUID.randomUUID().toString();
        Coupon coupon = new Coupon();

        Date expiration = new Date();
        long expTimeMillis = expiration.getTime();
        expTimeMillis += 1000 * 60 * 20;
        expiration.setTime(expTimeMillis);

        log.info(expiration.toString());

        try {

            GeneratePresignedUrlRequest generatePresignedUrlRequest =
                    new GeneratePresignedUrlRequest(bucket, fileName)
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
        coupon.setUser("testUser");
        coupon.setImageUrl(preSignedURL);
        couponService.saveCoupon(coupon);

        return preSignedURL;
    }
}