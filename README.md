![R (2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/2f6d1111-2741-4224-991b-8c3c6a660e26)
**تانل وایرگارد و OpenVPN با FRP**
--------------------------------------------------------

------------------------------------------------------------
![check](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/2a5e9652-9a0a-4b80-a9fc-db970d3804a0)
**امکانات** 

- به راحتی تانل را بر پایه ایپی ورژن 4 یا 6 برقرار کنید
- امکان برقرای تانل های udp - kcp - quic به صورت همزمان
- مناسب برای openvpn و wireguard
- تانل وایرگارد و openvpn با kcp
- تانل وایرگارد وopenvpn با quic
- امکان ویرایش ریست تایمر بر حسب دقیقه یا ساعت
- نمایش سرویس به صورت جداگانه
- به روز رسانی سرویس
- حذف سرویس

-----------------------------------------------------------------------------
- **تنها در صورتی میتوانید از چندین سرویس همزمان استفاده کنید که تمام پورت های کانفیگ و تانل متفاوت باشد و ریست تایمر تمام انها باید یکسان باشد وگرنه اختلال خواهید خورد**

-----------

![6348248](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/108ac290-671c-4280-99dc-290ed15f762f)
**آموزش**

- از optimizer برای بهبودی عملکرد سرور استفاده نمایید.
- اگر مشکلی در دانلود داشتید از temporary dns استفاده نمایید.
- وایرگارد یا openvpn را بر روی سرور خارج نصب نمایید.
- نخست سرور ایران را برای تانل کانفیگ کنید و سپس سرور خارج.
- پورت وایرگارد ایران و خارج میتواند یکی باشد. 

----------------------------------------------

 <div align="right">
  <details>
    <summary><strong><img src="https://github.com/Azumi67/Rathole_reverseTunnel/assets/119934376/fcbbdc62-2de5-48aa-bbdd-e323e96a62b5" alt="Image"> </strong> تانل وایرگارد با quic</summary>
  
  
------------------------------------ 


![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/902a2efa-f48f-4048-bc2a-5be12143bef3) **سرور ایران**



 <p align="right">
  <img src="https://github.com/Azumi67/FRP-Wireguard/assets/119934376/c2ffe7cf-736e-4461-81ab-cec51943ca77" alt="Image" />
</p>



- نخست سرور ایران را کانفیگ میکنیم
- میتوانید برای OPENVPN هم استفاده نمایید و این اموزش برای مثال است.
- کانفیگ سرور را با ایپی 4 یا 6 و بر روی تک سرور میخواهیم انجام دهیم
- پورت QUIC را وارد میکنم. شما میتوانید هر پورتی بگذارید
- پورت لوکال و ریموت را پورت کانفیگ وایرگارد را قرار میدهم. پورت وایرگارد من 20820 میباشد
- سپس ریست تایمر را عدد 4 ساعت میذارم. شما هر عددی دوست داشتید بذارید
----------------------

![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/902a2efa-f48f-4048-bc2a-5be12143bef3) **سرور خارج** 




<p align="right">
  <img src="https://github.com/Azumi67/FRP-Wireguard/assets/119934376/2cca74bf-a27a-43a0-be80-3ee807f75082" alt="Image" />
</p>

- تعداد کانفیگ من یک عدد میباشد پس یک را وارد میکنم
- ایپی 4 یا 6 سرور ایران را وارد میکنم
- پورت QUIC را 8443 مانند سرور ایران قرار میدم 
- پورت کانفیگم 20820 بود
- ریست تایمر هم بر حسب نیاز خودتان وارد کنید. من گیمر هستم پس 4 ساعت را انتخاب میکنم. بعدا از داخل منو میتوانید ویرایش نمایید
- ایپی ایران و پورت وایرگارد را در قسمت ENDPOINT وایرگارد وارد نمایید.
----------------

  </details>
</div>
 <div align="right">
  <details>
    <summary><strong><img src="https://github.com/Azumi67/Rathole_reverseTunnel/assets/119934376/fcbbdc62-2de5-48aa-bbdd-e323e96a62b5" alt="Image"> </strong> تانل OPENVPN با KCP</summary>
  
  
------------------------------------ 


![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/902a2efa-f48f-4048-bc2a-5be12143bef3) **سرور ایران**



 <p align="right">
  <img src="https://github.com/Azumi67/FRP-Wireguard/assets/119934376/7a44142b-91bf-400c-b001-5475c5eb6453" alt="Image" />
</p>



- نخست سرور ایران را کانفیگ میکنیم
- میتوانید برای وایرگارد هم انجام دهید. این تنها یک مثال است.
- کانفیگ سرور را با ایپی 4 یا 6 و بر روی تک سرور میخواهیم انجام دهیم
- پورت KCP را وارد میکنم. شما میتوانید هر پورتی بگذارید
- پورت لوکال و ریموت را پورت کانفیگ وایرگارد را قرار میدهم. پورت OVPN من 1180 میباشد
- سپس ریست تایمر را عدد 4 ساعت میذارم. شما هر عددی دوست داشتید بذارید
----------------------

![green-dot-clipart-3](https://github.com/Azumi67/6TO4-PrivateIP/assets/119934376/902a2efa-f48f-4048-bc2a-5be12143bef3) **سرور خارج** 



<p align="right">
  <img src="https://github.com/Azumi67/FRP-Wireguard/assets/119934376/cd515c57-35f3-41cd-9c27-7d39275ecf92" alt="Image" />
</p>

- تعداد کانفیگ من یک عدد میباشد پس یک را وارد میکنم
- ایپی 4 یا 6 سرور ایران را وارد میکنم
- پورت KCP را 443 مانند سرور ایران قرار میدم 
- پورت کانفیگم 1180 بود
- ریست تایمر هم بر حسب نیاز خودتان وارد کنید. من گیمر هستم پس 4 ساعت را انتخاب میکنم. بعدا از داخل منو میتوانید ویرایش نمایید
- ایپی ایران و پورت OVPN ؛ در کانفیگ OPENVPN را تغییر دهید.
----------------

  </details>
</div>
<div align="right">
  <details>
    <summary><strong><img src="https://github.com/Azumi67/Rathole_reverseTunnel/assets/119934376/fcbbdc62-2de5-48aa-bbdd-e323e96a62b5" alt="Image"> </strong>تانل وایرگارد SIMPLE | Multi UDP</summary>
  
  
------------------------------------ 

 ![green-dot-clipart-3](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d285f2bb-00ca-471b-95df-65d91eec2d9c)
**کانفیگ چندین پورت**

  
  <div dir="rtl">&bull; سرور ایران</div>
  <div align="right">
    
![Screenshot 2024-01-16 000130](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/0d10ccad-6ba7-4290-a21c-c8c6eeb448d1)

  - سرور ایران را کانفیگ میکنیم و پورت یا پورت های خود را قرار میدهیم.

---------------------------------------------
 
  <div dir="rtl">&bull; سرور خارج</div>
  <div align="right">
    
![kharej multi](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/80683a0c-f6be-42d9-95d4-e8064b5f4499)

 <div dir="rtl">&bull; تعداد ایپی 6 خارج را انتخاب کنید.</div>
 <div dir="rtl">&bull; ایپی 6 ایران را وارد نمایید.</div>
 <div dir="rtl">&bull; توکن و پورت تانل را وارد نمایید( مقدار یکسان برای سرور خارج و ایران)</div>
 <div dir="rtl">&bull; ایپی 6 اول و دوم و سوم خارج را وارد نمایید.</div>
 <div dir="rtl">&bull; پورت وایرگارد خارج و ایران برای هر ایپی 6 خارج وارد نمایید.( باید همان پورت ها را در سرور ایران هم وارد نمایید)</div>

</div>

  </details>
</div>

-----------------------------------------------
![R (a2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/9a84efc5-545d-4222-a851-9f08f573766c)
دستور اجرای اسکریپت 
```
bash <(curl -Ls https://raw.githubusercontent.com/Azumi67/FRP-Wireguard/main/wire2.sh --ipv4)
```
----------------------------------------------------------------

![R23 (1)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/ff23b9fa-a9da-428b-8bb6-e967160025d9)**: سورس اصلی**



[سورس FRP](https://github.com/fatedier/frp) ![R (6)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/b9993cf7-fddb-4c8e-8892-ecab0c2a0496)


