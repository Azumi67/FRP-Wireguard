![R (2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/3a051159-7849-42b0-97d6-90ea6e78d13f)Project Overview : Wireguard Tunnel based on FRP IPV4/6
--------------------------------
Languages :![lang](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/f641779b-624e-445a-9709-fe44caef0223)

- Click Persian to navigate to the selceted section.

[Persian](https://github.com/Azumi67/FRP-Wireguard/edit/main/README.md#%D8%AA%D8%A7%D9%86%D9%84-%D9%88%D8%A7%DB%8C%D8%B1%DA%AF%D8%A7%D8%B1%D8%AF-frp)

[English](https://github.com/Azumi67/FRP-Wireguard/edit/main/README.md#project-overview--wireguard-tunnel-based-on-frp-ipv46)

---------------------------------------------------------
![7115070](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d04e7b18-0b6d-4237-8447-2f7e1736a2dd)  WHAT IS FRP ? >> FRP is a fast reverse proxy that allows you to expose a local server behind a NAT or firewall to the Internet. It currently supports TCP and UDP as well as HTTP and HTTPS protocols, allowing requests to be forwarded to internal services via domain names.

------------------------------------------------------------------------------

![check](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/9445fa6e-9eff-4299-b65d-5115bf53aead) **Features:**

- Easy to use.
- You can easily tunnel by entering some manual input on either IPV4 or IPV6 to establish a tunnel.
- There is a service status on the main menu to show tunnel status.
- There is a restart button for restarting tunnel services.
- There is an installation with built-in IP forward and temporary DNS to help you install the FRP binary without any problems.
- There are cool animations to keep you entertained while setting up a tunnel.
- There will be a video tutorial soon.
----------------------------------------------------------------------------------------------------------------------------

![OIsP](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/bae77d47-ad4c-498b-8354-8ef8631e166d)**Screenshots**
<kbd>
 
![Screenshot 2023-10-06 131935](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/34360d9e-5dd4-475a-99af-80bf069c3312)


-----------------------------------------------------------------------------------------


![pngtree-stay-tuned-lettering-banner-png-image_238576](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/7ca06a6e-d94a-45b9-bfc6-0a71090fd10e) **Please stay tuned as I plan to add a lot of scripts just for tunneling between server and client**

-------------------------------------------------------------------------------------------------------------------------

![OIP](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/7a82e195-5beb-4a18-8365-5cd737525c66) **Download :** 
 - Copy link below
   
```
bash <(curl -Ls https://raw.githubusercontent.com/Azumi67/FRP-Wireguard/main/Wire.sh --ipv4)
```
- Use it at your own Risk !
-------------------------------------------------------------------------------------------------

![1234](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d1434ac2-94a9-44ef-8a14-84b981ab2e75) **Guide :** 

- For IPV6 tunneling : you can also choose local ip [127.0.0.1] for kharej/client or just insert your kharej/client IPV6.
- Use Iran/server Wireguard port to connect to the Internet
- Use Iran/Server IPV4 in endpoint.
- Wireguard port for Iran/Server and Kharej/Client should be different [For example, the kharej port is 50820 and the Iran port is 50821.]

------------------------------------------------------------------------------------------
![R23 (1)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/31baa226-5045-4489-90d2-1a066a91e880)
![circle-clipart-chain-link-9](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/348d93a7-b12b-414a-908d-664ea38f4cdf)[FRP-Source](https://github.com/fatedier/frp)

------------------------------------------------------------------------------------------------------------
![youtube-131994968075841675](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/dcde492b-ba44-4837-bb50-bbe4b3ac843a) **Video Guide :**  Soon

---------------------------------------------------------------------------------------------------------

![R (7)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/5024ce1e-1cbf-4855-9b78-497c39b9f2f8) **Telegram channel :**
![R (6)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/b9c77229-d9b2-42e3-910c-a0a2ea820c92) [OPIRAN](https://github.com/opiran-club)


-------------------------------------------------
**تانل وایرگارد FRP**
![R (2)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/2f6d1111-2741-4224-991b-8c3c6a660e26)
--------------------------------------------------------

------------------------------------------------------------

**امکانات** ![check](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/282de1ce-85b0-4a58-b0eb-af6b9004a04c)
- به راحتی تانل را بر پایه ایپی ورژن 4 یا 6 برقرار کنید
- نمایش سرویس در main menu
- به روز رسانی سرویس
- حذف سرویس

- -----------------------------------------------------------------------------

**آموزش**![1234](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/cdc497c3-3191-437e-8a85-13f4e9b68808)
- نخست سرور ایران را کانفیگ کنید و سپس سرور خارج.
- اگر تانل شما با قرار دادن ایپی 6 خارج کار نکرد، به جای قرار دادن ایپی 6 خارج از 127.0.0.1 استفاده نمایید و برای قسمت ایپی ایران از ایپی 6 ایران استفاده نمایید.
- پورت وایرگارد سرور ایران و خارج باید متفاوت باشد. شما وایرگارد را در سرور خارج نصب نمایید و به طور مثال پورت شما 50820 میباشد . پورت ایران شما مقدار متفاوتی به غیر از 50820 باید باشد. به عنوان مثال در قسمت ENDPOINT کلاینت وایرگارد، شما باید این مقدار را قرار دهید IPV4IRAN:50821

 


-----------------------------------------------
![R23 (1)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/ff23b9fa-a9da-428b-8bb6-e967160025d9)**: سورس اصلی**



[سورس FRP](https://github.com/fatedier/frp) ![R (6)](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/b9993cf7-fddb-4c8e-8892-ecab0c2a0496)

------------------------------------------------------------------


**آموزش یوتیوب:**![youtube-131994968075841675](https://github.com/Azumi67/FRP-Wireguard/assets/119934376/d9fb3c2c-5bdf-4854-8989-31f050432b6e)



