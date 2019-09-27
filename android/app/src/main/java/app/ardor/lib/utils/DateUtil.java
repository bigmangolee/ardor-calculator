package app.ardor.lib.utils;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
    public static final String MM_DD = "MM月dd日";
    public static final String YYYY_MM_DD = "yyyy-MM-dd";
    public static final String YYYYMMDD = "yyyyMMdd";
    public static final String YYYYMMDDHHMMSS = "yyyyMMddHHmmss";
    public static final String MMDD = "MM-dd";
    public static final String YYYYMM = "yyyyMM";
    public static final String YYYY_MM = "yyyy-MM";
    public static final String YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
    public static final String YYYY_MM_DD_HH_MM = "yyyy-MM-dd HH:mm";
    public static final String HHMM = "HH:mm";
    public static final String MMDD_HHMM = "MM/dd HH:mm";

    /**
     * 获取一个指定格式的String date
     * @param date          原数据
     * @param fromFormart   原数据格式
     * @param toFormart     你要变成什么格式
     * @return
     */
    public static String getFormatDateStr(String date,String fromFormart,String toFormart) {
        if(date!=null&&fromFormart!=null&&toFormart!=null){
            try {
                SimpleDateFormat fromSDF = new SimpleDateFormat(fromFormart);
                SimpleDateFormat sdf = new SimpleDateFormat(toFormart);
                Date tempDate = fromSDF.parse(date);
                return sdf.format(tempDate);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        return date;
    }

    /**
     * 获取一个指定格式的String date
     * @param figure	相对时间上加减 相应月数
     * @param format	格式化
     * @param date		相对时间
     * @return String date
     */
    public static String getStrDataDistanceByMonth(int figure,String format,Date date){
        SimpleDateFormat asf = new SimpleDateFormat(format);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.MONTH, figure);
        Date time  = calendar.getTime();
        return asf.format(time);
    }

    /**
     * 获取一个指定格式的String date
     * @param figure	相对时间上加减 相应天数
     * @param format	格式化
     * @param date		相对时间
     * @return String date
     */
    public static String getStrDataDistanceByDay(int figure,String format,Date date){
        SimpleDateFormat asf = new SimpleDateFormat(format);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_MONTH, figure);
        Date time  = calendar.getTime();
        return asf.format(time);
    }

    /**
     * 获取时间毫秒
     * @param figure   相对时间上加减 相应月份
     * @param date     时间
     * @return
     */
    public static long getLongDataDistanceByMonth(int figure,Date date){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(calendar.MONTH, figure);
        return calendar.getTimeInMillis();
    }


    /**
     *
     * @param figure
     * @param date
     * @param format
     * @return
     */
    public static String getNatureStrDataDistance(int figure,String date,String format){
        try{
            SimpleDateFormat asf = new SimpleDateFormat(format);
            Calendar calendar = Calendar.getInstance();
            Date tempDate = asf.parse(date);
            calendar.setTime(tempDate);
            calendar.add(calendar.MONTH, figure);
            calendar.set(Calendar.DATE, 1);
            Date time  = calendar.getTime();
            return asf.format(time);
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return date;

    }

    /**
     * 如果  data2 > date1   返回正整数  如大一天返回1
     * 如果  data2 = date1   返回0
     * 如果  data2 < date1   返回负整数  如大一天返回-1
     * @param date1
     * @param date2
     * @return
     * @throws java.text.ParseException
     */
    public static int getDateSpace(Date date1, Date date2)
            throws ParseException {

        Calendar calst = Calendar.getInstance();;
        Calendar caled = Calendar.getInstance();

        calst.setTime(date1);
        caled.setTime(date2);

        //设置时间为0时
        calst.set(Calendar.HOUR_OF_DAY, 0);
        calst.set(Calendar.MINUTE, 0);
        calst.set(Calendar.SECOND, 0);
        caled.set(Calendar.HOUR_OF_DAY, 0);
        caled.set(Calendar.MINUTE, 0);
        caled.set(Calendar.SECOND, 0);
        //得到两个日期相差的天数
        int days = ((int)(caled.getTime().getTime()/1000)-(int)(calst.getTime().getTime()/1000))/3600/24;

        return days;
    }

    /**
     * 解析日期格式（解析失败默认返回当前时间）
     * @param date
     * @param format
     * @return
     */
    public static Date parseDate(String date,String format){
        return parseDate(date, format, new Date());
    }

    /**
     * 解析日期格式
     * @param date
     * @param format
     * @param defaultDate
     * @return
     */
    public static Date parseDate(String date, String format, Date defaultDate){
        Date tempDate = null;
        try{
            SimpleDateFormat asf = new SimpleDateFormat(format);
            tempDate = asf.parse(date);
        }catch(Exception ex){
            ex.printStackTrace();
        }
        if (tempDate == null){
            return defaultDate;
        }
        return tempDate;
    }

    /**
     * 解析日期格式
     * @param date
     * @param format
     * @param defaultTimeStamp
     * @return
     */
    public static long parseTimeStamp(String date,String format, long defaultTimeStamp){
        Date tempDate = parseDate(date, format, null);
        if (tempDate == null){
            return defaultTimeStamp;
        }else{
            return tempDate.getTime();
        }
    }

    /**
     * 解析日期格式
     * @param date
     * @param format
     * @return
     */
    public static String formatDate(long date,String format){
        try{
            SimpleDateFormat asf = new SimpleDateFormat(format);
            return asf.format(new Date(date));
        }catch(Exception ex){
            ex.printStackTrace();
        }
        return "";
    }
}
