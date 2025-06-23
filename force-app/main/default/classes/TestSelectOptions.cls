public with sharing class TestSelectOptions {

    private List<String[]> labelValues = new List<String[]>{
        new String[]{'1','1 1'}, 
        new String[]{'12','2  2'}, 
        new String[]{'123','3   3'}, 
        new String[]{'1234','4    4'}, 
        new String[]{'12345','5     5'}, 
        new String[]{'123456','6      6'}, 
        new String[]{'1234567','7       7'}, 
        new String[]{'12345678','8        8'}, 
        new String[]{'123456789','9         9'} 
    };
    
    private Integer lsize = labelValues.size();
    private String[] lbls = new String[lsize], vals = new String[lsize];
     
    Map<String, SelectOption> map1;
    Map<String, SelectOption> map2;
    
    public String[] sos1 {get; set;}
    public String[] sos2 {get; set;}
    public String[] sos3 {get; set;}
    
    private void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }
    
    public void init() {
        map1 = new Map<String, SelectOption>();
        map2 = new Map<String, SelectOption>();
        sos1 = new String[]{};
        sos2 = new String[]{};
        SelectOption so; String l, v;
        for (Integer i=0; i<lsize; i++) {
            l = labelValues[i][0];
            v = labelValues[i][1];
            v = v.replaceAll(' ', '&nbsp;');
            lbls[i] = l;
            vals[i] = v;
            so = new SelectOption(v, v);
            so.setEscapeItem(false);
            map1.put(v, so);
        }
    } 

    public List<SelectOption> getOpts1() {return getOpts(map1);}
    public List<SelectOption> getOpts2() {return getOpts(map2);}
    
    private List<SelectOption> getOpts(Map<String, SelectOption> smap) {
        List<SelectOption> sos = new List<SelectOption>();
        for (String s : vals) {
            if (smap.containsKey(s)) {
                sos.add(smap.get(s));
            }
        }
        return sos;
    }

    private void move(Map<String, SelectOption> fmap,
                      Map<String, SelectOption> tmap, 
                      String[] sa) {
        for (String s : sa) {
        	//debug(s);
            if (fmap.containsKey(s)) {
                tmap.put(s, fmap.get(s));
                fmap.remove(s);
            }
        }
    } 
    
    public void add()       {move(map1, map2, sos1);} 
    public void addAll()    {move(map1, map2, vals);}
     
    public void remove()    {move(map2, map1, sos2);}
    public void removeAll() {move(map2, map1, vals);}
    
    public void setsos3() {
        sos3 = new List<String>();
        List<SelectOption> sos = getOpts2();
        String v;
        for (SelectOption so : sos) {
        	v = so.getValue();
        	v = v.replaceAll('&nbsp;', ' ');
            sos3.add(v);
        }
    }
    
    @isTest static void test01() {
    	TestSelectOptions c = new TestSelectOptions();
    	c.init();      c.debug('map1 : '+c.map1);
    	c.addAll();    c.debug('map2 : '+c.map2);
    	c.removeAll(); c.debug('map2 : '+c.map2);
        c.addAll();    c.debug('map2 : '+c.map2);
    	c.setsos3();   c.debug('sos3 : '+c.sos3);
    }
    
}