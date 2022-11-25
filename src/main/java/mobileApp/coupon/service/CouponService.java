package mobileApp.coupon.service;

import mobileApp.coupon.Coupon;
import mobileApp.coupon.S3Uploader;
import mobileApp.coupon.repository.CouponRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.List;

@Service
@Transactional
public class CouponService {
    private final CouponRepository couponRepository;

    @Autowired
    private S3Uploader s3Uploader;

    @Autowired
    public CouponService(CouponRepository couponRepository) {
        this.couponRepository = couponRepository;
    }

    public void saveCoupon(Coupon coupon){
        couponRepository.save(coupon);
    }

    public Long keepCoupon(MultipartFile image, Coupon coupon) throws IOException {
        System.out.println("Diary service saveDiary");
        if(!image.isEmpty()) {
            System.out.println("image not empty");
            String storedFileName = s3Uploader.upload(image,"test");
            coupon.setImageUrl(storedFileName);
        }
        Coupon savedCoupon = couponRepository.save(coupon);
        return savedCoupon.getId();
    }

    public List<Coupon> findByUser(String name){
        return couponRepository.findByUser(name);
    }


}
