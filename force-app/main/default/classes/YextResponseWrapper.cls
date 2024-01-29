public class YextResponseWrapper {
    public cls_response response;
    public class cls_meta {
        public String id;
    }
    public class cls_response {
        public cls_entities[] entities;
        public String pageToken;
    }
    public class cls_entities {
        public cls_address address;
        public cls_hours hours;
        public String name;	
        public boolean closed;
        public String mainPhone;
        public cls_websiteUrl websiteUrl;
        public cls_meta meta;
        public String additionalHoursText;
    }
    public class cls_address {
        public String line1;
        public String line2;	
        public String city;	
        public String region;
        public String postalCode;	
        public String countryCode;
    }
    public class cls_hours {
        public cls_monday monday;
        public cls_tuesday tuesday;
        public cls_wednesday wednesday;
        public cls_thursday thursday;
        public cls_friday friday;
        public cls_saturday saturday;
        public cls_sunday sunday;
        public cls_holidayHours[] holidayHours;
    }
    public class cls_monday {
        public cls_openIntervals[] openIntervals;
    }
    public class cls_openIntervals {
        public String start;	
        public String endTime;	
    }
    public class cls_tuesday {
        public cls_openIntervals[] openIntervals;
    }
    public class cls_wednesday {
        public cls_openIntervals[] openIntervals;
    }
    public class cls_thursday {
        public cls_openIntervals[] openIntervals;
    }
    public class cls_friday {
        public cls_openIntervals[] openIntervals;
    }
    public class cls_saturday {
        public cls_openIntervals[] openIntervals;
    }
    public class cls_sunday {
        public cls_openIntervals[] openIntervals;
    }
    public class cls_holidayHours {
        public String holidayDate;
        public boolean isClosed;
        public cls_openIntervals[] openIntervals;
    }
    public class cls_websiteUrl {
        public String url;
    }
}