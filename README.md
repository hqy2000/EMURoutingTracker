# ChinaEMU Tracker

An app that tracks China's Electric Multiple Unit trains. It allows users to query realtime information about the EMUs, for example the detailed assignment of fleets (including history up to 1 month). Built with SwiftUI. Now avaialble in [App Store](https://apps.apple.com/us/app/%E5%8A%A8%E8%BD%A6%E7%BB%84%E4%BA%A4%E8%B7%AF%E6%9F%A5%E8%AF%A2/id1471687297) for iPhone, iPad, and Mac. Features:

- You can search the realtime information of trains by train numbers (e.g. G2), and that of EMUs by fleet number (e.g. CRH2A-2001).
- You can look up multiple records with fuzzy search (e.g CRH2A would give you the results for all trains belonging to CRH2A series).
- You can check the realtime information along with the timetable by providing the from and the to station.
- You can favorite a train or EMU and it will show up in the favorite tab.
- You can add a widget to your home screen for quick access to your favorites.
- You can report inaccruate information by scanning the QR code in the train.

The app relies on the backend from [MoeRail](https://moerail.ml). You can check the source code of the backend at [Arnie97/emu-log](https://github.com/Arnie97/emu-log).

# 交路查询

一款关于中国铁路动车组列车交路的 app。基于 SwiftUI 开发。现已上架 [App Store](https://apps.apple.com/cn/app/%E5%8A%A8%E8%BD%A6%E7%BB%84%E4%BA%A4%E8%B7%AF%E6%9F%A5%E8%AF%A2/id1471687297)，可用于 iPhone、iPad，及 Mac。

- 支持精确车次（如 G2）或车组号（如 CRH2A-2001）查询。
- 支持模糊查询（如 CRH2A，显示 CRH2A 系列所有车辆的运用信息）。
- 支持时刻表查询（提供到发站）。
- 支持收藏列车或动车组。收藏后的列车及动车组会自动显示在收藏页面上，无需再次手动查询。
- 支持桌面小组件，方便查看收藏列车的相关信息。
- 支持通过扫描点餐二维码自动上报不准确的信息。

本 app 数据来自 [MoeRail](https://moerail.ml)。 其源码开放于 [Arnie97/emu-log](https://github.com/Arnie97/emu-log)。

![](https://user-images.githubusercontent.com/12138874/148732779-38ef27ff-f9f1-42bd-a5da-7414bae21530.png)  |  ![](https://user-images.githubusercontent.com/12138874/148732799-8b738924-53bd-4f37-8c8b-8140288d893d.png)
:-------------------------:|:-------------------------:
![](https://user-images.githubusercontent.com/12138874/148732811-c392cd59-40af-400b-9b8c-96ae9936969f.png)  |  ![](https://user-images.githubusercontent.com/12138874/148732818-d017da06-4053-457b-ad4f-f8f21b90d887.png)
