class GifticonInfo{
  // ID, 이름, 유효기간, 알림일
  String id;
  String name;
  String img;
  DateTime deadline;
  int alarm;

  GifticonInfo(
      this.id,
      this.name,
      this.img,
      this.deadline,
      this.alarm,
      );
}