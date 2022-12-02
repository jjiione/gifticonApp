package mobileApp.coupon.controller;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.Headers;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import mobileApp.coupon.Coupon;
import mobileApp.coupon.S3Uploader;
import mobileApp.coupon.dto.FileName;
import mobileApp.coupon.dto.Url;
import mobileApp.coupon.service.CouponService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.net.URL;
import java.util.Date;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/app/image")
public class ImageController {
    @Autowired
    AmazonS3Client amazonS3Client;
    private final S3Uploader s3Uploader;

    @Autowired
    private CouponService couponService;

    //test용 원래 flutter에서 받아올 것
    private FileName fileName = null;
    private String name;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Value("${cloud.aws.s3.bucket.url")
    private String objectKey;

    @PostMapping("set/fileName")
    @ApiOperation(value = "파일 이름 등록")
    public FileName registerFileName(@RequestBody FileName fileName){
        this.fileName = fileName;
        return this.fileName;
    }

    @GetMapping("set/fileName")
    @ApiOperation(value = "이미지 파일 이름 세팅", notes = "이미지 파일 이름 등록한다")
    public FileName getFileName(){
        if (fileName == null){
            FileName errorFileName = new FileName();
            errorFileName.setFileName("file name is not setting ");
            return errorFileName;
        }
        return this.fileName;

    }

    @GetMapping("/get/preSignedUrl")   // 수정 됨
    @ApiOperation(value = "이미지 등록 url 생성")
    public Url postUrl(){
        Url preUrl = new Url();
        preUrl.setUrl(getPreSignedURL());
        return preUrl;
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
