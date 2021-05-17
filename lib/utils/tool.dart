String epochToDateTime(int epoch) {
  final dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
  return '${dt.month}/${dt.day}/${dt.year} ${dt.hour}:${dt.minute}';
}

String epochToCustomTimeDisplay(int epoch) {
  final dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
  final dtNow = DateTime.now();
  if (dt.isBefore(dtNow.subtract(Duration(days: 7)))) {
    return '${dt.month}/${dt.day}/${dt.year}';
  } else if (dt.isBefore(dtNow.subtract(Duration(days: 1)))) {
    final int days = dtNow.difference(dt).inDays;
    return days == 1 ? '${days} day ago' : '${days} days ago';
  } else if (dt.isBefore(dtNow.subtract(Duration(hours: 1)))) {
    final int hours = dtNow.difference(dt).inHours;
    return hours == 1 ? '${hours} hour ago' : '${hours} hours ago';
  } else if (dt.isBefore(dtNow.subtract(Duration(minutes: 1)))) {
    final int minutes = dtNow.difference(dt).inMinutes;
    return minutes == 1 ? '${minutes} minute ago' : '${minutes} minutes ago';
  } else if (dt.isBefore(dtNow.subtract(Duration(seconds: 1)))) {
    final int seconds = dtNow.difference(dt).inSeconds;
    return seconds == 1 ? '${seconds} second ago' : '${seconds} seconds ago';
  } else {
    return 'right now';
  }
}
