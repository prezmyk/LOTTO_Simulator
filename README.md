# LOTTO_Simulator

LOTTO Simulator in a Cloud Autonomous Oracle Database 19c

## Details 
There are 2 number games: 

##### BIG LOTTO 
- 6 numbers of 49 with cumulative JACKPOT (stopped over 100000000). 

##### EXPRESS LOTTO 
- 5 numbers of 42 with constant max winning amount (500000).

#### BIG LOTTO Amounts for matched numbers:

3 - 20

4 - 500 

5 - 2000

6 - JACKPOT

Coupon price  - 2

#### EXPRESS LOTTO Amounts for matched numbers:
4 - 10

5 - 1000 

5 - 500000

coupon price  - 1.5
 

## Try as Guest User in the Cloud Autonomous Database

<details><summary style="color:orange;">Show/Hide</summary>  
<p>
  
[LINK](https://g40fde3dc770a47-yc4l01uh4y51whe6.adb.eu-frankfurt-1.oraclecloudapps.com/ords/lotto_user/sign-in/?username=LOTTO_USER&r=_sdw%2F)

| Login     | Password    | 
| :-------- | :-------    | 
| `LOTTO_USER` | `GUEST$haslo1`    | 

</p>

</p>
</details>

A guest user with select privileges on tables, views and package to pick numbers on coupon for BIG or EXPRESS LOTTO on LOTTO database.

#### Example PL/SQL BLOCK
```SQL
SET SERVEROUTPUT ON
DECLARE
t_number coupons_numbers_pkg.numbers_array;
BEGIN
t_number := coupons_numbers_pkg.numbers_array(1,2,3,4,5,6); -- Numbers for coupon
coupons_numbers_pkg.coupon_numbers (t_number, p_game_id => 10);
END;
/
```

