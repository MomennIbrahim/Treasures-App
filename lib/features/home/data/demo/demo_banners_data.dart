import 'package:konoz/features/home/data/model/banners_model.dart';

class DemoBannersData {
  static final BannersModel banners = BannersModel(
    success: true,
    message: 'Demo Data',
    bannersData: [
      BannerData(
        image:
            'https://i.pinimg.com/736x/91/46/b1/9146b1806b9cc89d22d12ccb987e0d5a.jpg',
        title: 'New perfume collection 2026',
        subtitle: 'Choose perfect perfume for your life style',
        buttonLabel: 'Shop Now',
      ),
      BannerData(
        image:
            'https://i.pinimg.com/736x/5a/f1/55/5af155369c988b9bf76a506d7c846a1b.jpg',
        title: 'Limited Edition',
        subtitle: 'Exclusive scents crafted for you',
        buttonLabel: 'Explore',
      ),
      BannerData(
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRylEOduNlj_SZdJbNm7k0KUS_18QdEHPjFWM8gcj2SHwGJBzueARYk_50&s=10',
        title: 'Limited Edition',
        subtitle: 'Exclusive scents crafted for you',
        buttonLabel: 'Shop Now',
      ),
    ],
  );
}
