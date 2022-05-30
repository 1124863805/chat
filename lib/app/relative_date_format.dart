class RelativeDateFormat {
  static final num ONE_MINUTE = 60000;
  static final num ONE_HOUR = 3600000;
  static final num ONE_DAY = 86400000;
  static final num ONE_WEEK = 604800000;

  static final String ONE_SECOND_AGO = "秒前";
  static final String ONE_MINUTE_AGO = "分钟前";
  static final String ONE_HOUR_AGO = "小时前";
  static final String ONE_DAY_AGO = "天前";
  static final String ONE_MONTH_AGO = "月前";
  static final String ONE_YEAR_AGO = "年前";

//时间转换
  static String format(DateTime dateTime) {
    DateTime now = DateTime.now();
    var difference = now.difference(dateTime);
    var t = '刚刚';
    if (difference.inDays > 365) {
      t = '${(difference.inDays / 365).round()}年前';
    } else if (difference.inDays >= 30) {
      t = '${(difference.inDays / 30).round()}月前';
    } else if (difference.inDays >= 1 || difference.inHours > 23) {
      t = '${difference.inDays}天前';
    } else if (difference.inHours >= 1) {
      t = '${difference.inHours}小时前';
    } else if (difference.inMinutes >= 1) {
      t = '${difference.inMinutes}分钟前';
    }
    return t;
  }

  static String _format(DateTime date) {
    num delta = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    // 3086269
    if (delta < 1 * ONE_MINUTE) {
      num seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toInt().toString() + ONE_SECOND_AGO;
    }
    if (delta < 45 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toInt().toString() + ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      num hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toInt().toString() + ONE_HOUR_AGO;
    }
    if (delta < 48 * ONE_HOUR) {
      return "昨天";
    }
    if (delta < 30 * ONE_DAY) {
      num days = toDays(delta);
      return (days <= 0 ? 1 : days).toInt().toString() + ONE_DAY_AGO;
    }
    if (delta < 12 * 4 * ONE_WEEK) {
      num months = toMonths(delta);
      return (months <= 0 ? 1 : months).toInt().toString() + ONE_MONTH_AGO;
    } else {
      num years = toYears(delta);
      return (years <= 0 ? 1 : years).toInt().toString() + ONE_YEAR_AGO;
    }
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toDays(date) / 365;
  }
}
