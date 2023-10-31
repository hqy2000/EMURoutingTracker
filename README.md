# EMU Routing Tracker

An app that tracks the routing of Electric Multiple Unit (EMU) trains in China. It allows users to query real-time information about the EMUs, including detailed assignment of fleets (with history up to one month). Built with SwiftUI, the app is now available on the [App Store](https://apps.apple.com/us/app/%E5%8A%A8%E8%BD%A6%E7%BB%84%E4%BA%A4%E8%B7%AF%E6%9F%A5%E8%AF%A2/id1471687297) for iPhone, iPad, and Mac. 

- Search for real-time information on trains by train numbers (e.g., G2) and on EMUs by fleet number (e.g., CRH2A-2001).
- Look up multiple records with fuzzy search (e.g., CRH2A will give you the results for all trains belonging to the CRH2A series).
- Check real-time information along with the timetable by providing both the "from" and "to" stations.
- Favorite a train or EMU, which will then appear in the "Favorites" tab.
- Add a widget to your home screen for quick access to your favorites.
- Report inaccurate information by scanning the QR code inside the train.

The app relies on the backend from [MoeRail](https://rail.re). You can check the source code of the backend at [Arnie97/emu-log](https://github.com/Arnie97/emu-log).

# 交路查询 

一款关于中国铁路动车组列车交路的 app。基于 SwiftUI 开发。现已上架 [App Store](https://apps.apple.com/cn/app/%E5%8A%A8%E8%BD%A6%E7%BB%84%E4%BA%A4%E8%B7%AF%E6%9F%A5%E8%AF%A2/id1471687297)，可用于 iPhone、iPad，及 Mac。

- 支持精确车次（如 G2）或车组号（如 CRH2A-2001）查询。
- 支持模糊查询（如 CRH2A，显示 CRH2A 系列所有车辆的运用信息）。
- 支持时刻表查询（提供到发站）。
- 支持收藏列车或动车组。收藏后的列车及动车组会自动显示在收藏页面上，无需再次手动查询。
- 支持桌面小组件，方便查看收藏列车的相关信息。
- 支持通过扫描点餐二维码自动上报不准确的信息。

本 app 数据来自 [MoeRail](https://rail.re)。 其源码开放于 [Arnie97/emu-log](https://github.com/Arnie97/emu-log)。

![](https://user-images.githubusercontent.com/12138874/148732779-38ef27ff-f9f1-42bd-a5da-7414bae21530.png)  |  ![](https://user-images.githubusercontent.com/12138874/148732799-8b738924-53bd-4f37-8c8b-8140288d893d.png)
:-------------------------:|:-------------------------:
![](https://user-images.githubusercontent.com/12138874/148732811-c392cd59-40af-400b-9b8c-96ae9936969f.png)  |  ![](https://user-images.githubusercontent.com/12138874/148732818-d017da06-4053-457b-ad4f-f8f21b90d887.png)
