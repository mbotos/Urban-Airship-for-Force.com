public with sharing class Utility {
	
	public static String joinStrings(List<string> items, string delimiter) {
	    string s = '';
	    integer i = 0;
	
	    for (string item : items) {
	        if (i++ > 0) { 
	            s += delimiter; 
	        }
	        s += item;
	    }
	
	    return s;
	}

}