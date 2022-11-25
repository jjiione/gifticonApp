package mobileApp.coupon;

import lombok.*;

import javax.persistence.*;
import java.util.Date;

@Getter
@Setter
@ToString
@NoArgsConstructor @AllArgsConstructor
@Entity
public class Coupon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private String user;

    @Column(length = 500)
    private String imageUrl;

    @Column
    private String brand;

    @Column
    private String couponName;

    @Column
    private String date;

    @Column
    private String isUsed;

    @Column
    private int timer;

}
