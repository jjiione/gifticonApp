package mobileApp.coupon.controller;

import io.swagger.annotations.ApiOperation;
import mobileApp.coupon.Coupon;
import mobileApp.coupon.service.CouponService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/app/coupon")
public class CouponController {
    private CouponService couponService;
    @Autowired
    CouponController(CouponService couponService){
        this.couponService = couponService;
    }


    @GetMapping("/{user}")
    @ApiOperation(value = "해당 user의 쿠폰 전체 조회", notes = "매개변수로 사용자 정보(ex.email)를 받아서 해당 user가 가지고 있는 쿠폰 조회")
    @ResponseBody
    public List<Coupon> getCouponByUser(@PathVariable String user){
        return couponService.findByUser(user);
    }

    @PostMapping("register")
    @ApiOperation(value = "쿠폰 등록", notes = "body로 coupon객체를 json으로 받아서 DB에 저장")
    public Coupon testCouponRegister(@RequestBody Coupon coupon){
        couponService.saveCoupon(coupon);
        return coupon;
    }

    @PutMapping("change/{couponId}")
    @ApiOperation(value = "쿠폰 정보 변경", notes = "해당 쿠폰 id를 가지고 있는 coupon객체를 수정한다. " +
            "수정된 내용 coupon객체를 body에 json으로 담아서 보내주면 해당 쿠폰 id를 가지고 있는 coupon객제를 전달 받은 값으로 변경한다 ")
    public Coupon changeIsUsed(@PathVariable long couponId, @RequestBody Coupon coupon){
        return couponService.couponUpdate(couponId, coupon);
    }

    @DeleteMapping("delete/{couponId}")
    @ApiOperation(value = "쿠폰 삭제")
    public String deleteCoupon(@PathVariable long couponId){
        return couponService.deleteCoupon(couponId);
    }

}
