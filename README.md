**تانل وایرگارد FRP**
![R (2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/2f6d1111-2741-4224-991b-8c3c6a660e26)
--------------------------------------------------------

------------------------------------------------------------
![Update-Note--Arvin61r58](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/9e6f78ec-9286-4e0a-888e-d8c29f2fc486) 
**امکان تانل با چندین پورت متفاوت و با چندین ایپی 6 هم در سرور خارج و ایران فراهم شد**

**پشتیبانی از amd64 و arm**
  - ریستارت تایمر 2 ساعته برای تانل FRP اضافه شد.
  - حذف ایپی 6 برای ایران و استفاده از لوکال ایپی برای ساده تر کردن اجرای تانل مولتی پورت
  - شما مانند قبل سرور خارج را کاتفیگ میکنید و تنها کافی هست که سرور ایران را متفاوت کانفیگ نمایید
  - در سرور ایران تنها کافی میباشد که پورت های وایرگارد خارج و ایران را بدهید
  - به طور مثال اگر پورت های وایرگارد شما 50820 و 50821 میباشد در قسمت پورت وایرگارد خارج مقدار 50820,50821 را قرار میدهید ( دقیقا به همین صورت وارد نمایید)
  - و برای پورت های وایرگارد ایران به طور مثال 50822,50823 را قرار میدهیم
  - پس در کلاینت وایرگارد ایپی و پورت ما اینگونه میباشد سرور اول : IPV4-IRAN:50822  سرور دوم : IPV4-IRAN:50823

---------------------------------


![check](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/2a5e9652-9a0a-4b80-a9fc-db970d3804a0)
**امکانات** 

- به راحتی تانل را بر پایه ایپی ورژن 4 یا 6 برقرار کنید
- نمایش سرویس در main menu
- به روز رسانی سرویس
- حذف سرویس

- -----------------------------------------------------------------------------

![1234](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/786573e0-752a-4ec0-b41b-02dedff28225)
**آموزش**

- میتوانید از VPS Optimizer [اپیران](https://github.com/opiran-club/VPS-Optimizer) برای بهبودی عملکرد استفاده نمایید 
```
apt install curl -y && bash <(curl -s https://raw.githubusercontent.com/opiran-club/VPS-Optimizer/main/optimizer.sh --ipv4)
```
- وایرگارد را بر روی سرور خارج نصب نمایید.
- نخست سرور ایران را برای تانل کانفیگ کنید و سپس سرور خارج.
- پورت وایرگارد ایران و خارج نباید یکی باشد. پورت وایرگارد خارج اگر 50820 است، پورت وایرگارد ایران به طور مثال 50821 خواهد بود.
- به طور مثال : وایرگارد را در سرور خارج نصب میکنم و پورت هم 50820 قرار میدم سپس بر روی سرور ایران اسکریپت را اجرا میکنم و پورت تانل را 443 قرار میدم و توکن هم azumi قرار میدم .  سپس بر روی سرور خارج ایپی 6 خارج و ایران، پورت تانل 443 و توکن هم azumi قرار میدم . پورت وایرگارد ایران 50821 و پورت وایرگارد خارج 50820 میگذارم. و در کلاینت وایرگارد در قسمت endpoint این عبارت روبرو را جایگذاری میکنم. IPV4-IRAN:50821


 ![green-dot-clipart-3](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d285f2bb-00ca-471b-95df-65d91eec2d9c)
**کانفیگ چندین پورت**

----------------------------------------------
  
  <div dir="rtl">&bull; سرور ایران</div>

   
   ![iran multi](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/a68d78cb-589d-4b85-a291-dbfebcadc18a)
  
   <div dir="rtl">&bull; نخست سرور ایران را کانفیگ کنید و سپس خارج.</div>
 <div dir="rtl">&bull; تعداد ایپی 6 ایران را انتخاب کنید.</div>
  <div dir="rtl">&bull; توکن و پورت تانل را وارد نمایید ( مقدار یکسان برای سرور خارج و ایران )</div>
   <div dir="rtl">&bull; ایپی 6 اول و دوم و سوم ایران را وارد نمایید.</div>
    <div dir="rtl">&bull; پورت وایرگارد خارج و ایران برای هر ایپی 6 ایران وارد نمایید ( باید همان پورت هایی باشد که در سرور خارج وارد کرده اید)</div>
     <div dir="rtl">&bull; میتوانید از سرور ایران تک کانفیگ هم استفاده کنید اما به جای پورت های وایرگارد خارج . ایران از Port range استفاده نمایید. مثلا برای وایرگارد خارج طبق عکس بالا = 50820,50822 و برای ایران = 50821,50823</div>
  

---------------------------------------------
 
  <div dir="rtl">&bull; سرور خارج</div>
  
![kharej multi](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/80683a0c-f6be-42d9-95d4-e8064b5f4499)
 <div dir="rtl">&bull; تعداد ایپی 6 خارج را انتخاب کنید.</div>
 <div dir="rtl">&bull; ایپی 6 ایران را وارد نمایید.</div>
 <div dir="rtl">&bull; توکن و پورت تانل را وارد نمایید( مقدار یکسان برای سرور خارج و ایران)</div>
 <div dir="rtl">&bull; ایپی 6 اول و دوم و سوم خارج را وارد نمایید.</div>
 <div dir="rtl">&bull; پورت وایرگارد خارج و ایران برای هر ایپی 6 خارج وارد نمایید.( باید همان پورت ها را در سرور ایران هم وارد نمایید)</div>


-----------------------------------------------
![R (a2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/9a84efc5-545d-4222-a851-9f08f573766c)
دستور اجرای اسکریپت 
```
bash <(curl -Ls https://raw.githubusercontent.com/Azumi67/FRP-Wireguard/main/Wire.sh --ipv4)
```
----------------------------------------------------------------

![R23 (1)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/ff23b9fa-a9da-428b-8bb6-e967160025d9)**: سورس اصلی**



[سورس FRP](https://github.com/fatedier/frp) ![R (6)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/b9993cf7-fddb-4c8e-8892-ecab0c2a0496)

------------------------------------------------------------------
![R (2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/3a051159-7849-42b0-97d6-90ea6e78d13f)Project Overview : Wireguard Tunnel based on FRP IPV4/6
--------------------------------
![lang](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/76f0a24c-7a39-4fa3-88ed-5428d1c90007) **Languages :**


- Click Persian to navigate to the selceted section.

1. [Persian](https://github.com/Azumi67/FRP-Wireguard/blob/main/README.md#%D8%AA%D8%A7%D9%86%D9%84-%D9%88%D8%A7%DB%8C%D8%B1%DA%AF%D8%A7%D8%B1%D8%AF-frp)

2. [English](https://github.com/Azumi67/FRP-Wireguard/blob/main/README.md#project-overview--wireguard-tunnel-based-on-frp-ipv46)

---------------------------------------------------------
![7115070](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d04e7b18-0b6d-4237-8447-2f7e1736a2dd)  WHAT IS FRP ? >> FRP is a fast reverse proxy that allows you to expose a local server behind a NAT or firewall to the Internet. It currently supports TCP and UDP as well as HTTP and HTTPS protocols, allowing requests to be forwarded to internal services via domain names.

------------------------------------------------------------------------------
![Update-Note--Arvin61r58](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/bace3b9b-4ac8-4e4f-9e0d-155d69ffcf32)
- Added Mutli configuration for different ports with IPV6 for both iran and kharej.
- Supports amd64 & arm
-------------------------------

![check](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/9445fa6e-9eff-4299-b65d-5115bf53aead) **Features:**

- Easy to use.
- You can easily tunnel by entering some manual input on either IPV4 or IPV6 to establish a tunnel.
- There is a service status on the main menu to show tunnel status.
- There is a restart button for restarting tunnel services.
- There is an installation with built-in IP forward and temporary DNS to help you install the FRP binary without any problems.
- There are cool animations to keep you entertained while setting up a tunnel.
- There will be a video tutorial soon.
----------------------------------------------------------------------------------------------------------------------------
![1234](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d1434ac2-94a9-44ef-8a14-84b981ab2e75) **Guide :** 

- You can optimize your server with [OPIRAN Optimizer](https://github.com/opiran-club/VPS-Optimizer)
  ```
  apt install curl -y && bash <(curl -s https://raw.githubusercontent.com/opiran-club/VPS-Optimizer/main/optimizer.sh --ipv4)
   ```
  
  - or you can use [hwashemi script](https://github.com/hawshemi/Linux-Optimizer)
    
  ```
  wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/linux-optimizer.sh" -O linux-optimizer.sh && chmod +x linux-optimizer.sh && bash linux-optimizer.sh 
  ```

- Be sure to install Wireguard on your Server/Kharej
- First, Start configuring Iran server, then Kharej/Client server.
- For IPV6 tunneling : you can also choose local ip [127.0.0.1] for kharej/client or just insert your kharej/client IPV6.
- Use Iran/server Wireguard port to connect to the Internet
- Use Iran/Server IPV4 in endpoint.
- Wireguard port for Iran/Server and Kharej/Client should be different [For example, the kharej port is 50820 and the Iran port is 50821.] Your Wireguard endpoint >> IPV4IRAN:50821

 - Example: I install Wireguard on my client / Kharej side and I choose 50820 for Wireguard port. Then I configure iran server using FRP script. I choose 443 for tunnel port and Azumi 
  for token. Then it is time to configure Kharej side [same values for Kharej side].
  I choose 50820 for Kharej Wireguard port and 50821 for Iran Wireguard port. So in Wireguard client the endpoint will look like this >> IPV4-IRAN:50821
  - If you have any problems, contact me.

**Multi Config**
- Iran side

  ![iran multi](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/33b1a17b-ec17-403c-a32d-cb9dc40b14b2)
  - First configure iran server and both local[iran] and remote[kharej] port can be the same port.
  - Choose the number of ipv6 that you need on iran side
  - Enter tunnel token and port [ the same value on kharej side]
  - Enter your first, second and third Iran IPV6 addresses based on the number of ipv6 addresses you have selected.
  - Enter your Kharej and Iran Wireguard port for each Kharej IPv6 address [you should enter the same port as you have entered here on the Kharej side].
    
- Kharej side
 
![kharej multi](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/fabeb685-d7be-49df-82cd-f1e62b4912d2)

- Choose the number of ipv6 that you need on kharej side
- Enter your iran IPV6 address
- Enter both tunnel token and port [ same value for both iran and kharej]
- Enter your first, second and third Kharej IPV6 addresses based on the number of ipv6 addresses you have selected.
- Enter your Kharej and Iran Wireguard port for each Kharej IPv6 address [you should enter the same port as you have entered here on the Iran side].



  -------------------------------------------------------------------------------------
  ![R (a2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/14145d9d-93d4-4b64-8907-b97ffb73f09f) **My Script**

 - Copy link below
   
```
bash <(curl -Ls https://raw.githubusercontent.com/Azumi67/FRP-Wireguard/main/Wire.sh --ipv4)
```
- Use it at your own Risk !
-------------------------------------------------------------------------------------------------

![OIsP](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/bae77d47-ad4c-498b-8354-8ef8631e166d) **Screenshots**
<kbd>
 
![logo](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/f1b71450-8794-4d54-897b-fb5564d37416)



-----------------------------------------------------------------------------------------


![pngtree-stay-tuned-lettering-banner-png-image_238576](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/7ca06a6e-d94a-45b9-bfc6-0a71090fd10e) **Please stay tuned as I plan to add a lot of scripts just for tunneling between server and client**

-------------------------------------------------------------------------------------------------------------------------

![R23 (1)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/31baa226-5045-4489-90d2-1a066a91e880)
![circle-clipart-chain-link-9](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/348d93a7-b12b-414a-908d-664ea38f4cdf)[FRP-Source](https://github.com/fatedier/frp)

------------------------------------------------------------------------------------------------------------
![youtube-131994968075841675](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/dcde492b-ba44-4837-bb50-bbe4b3ac843a) **Video Guide :**  Soon

---------------------------------------------------------------------------------------------------------

![R (7)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/5024ce1e-1cbf-4855-9b78-497c39b9f2f8) **Telegram channel :**
![R (6)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/f81bf6e1-cfed-4e24-b944-236f5c0b15d3) [اپیران- OPIRAN](https://t.me/OPIranClubb)


-------------------------------------------------



![youtube-131994968075841675](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d9fb3c2c-5bdf-4854-8989-31f050432b6e)
**آموزش یوتیوب:**



