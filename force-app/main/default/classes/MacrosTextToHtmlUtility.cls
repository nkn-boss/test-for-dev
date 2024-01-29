public class MacrosTextToHtmlUtility {
    public String fileNameInStaticResource;
    public String parentId;
    
    public MacrosTextToHtmlUtility(String fileName, String parentId) {
        this.fileNameInStaticResource = fileName;
        this.parentId = parentId;
    }
    
    public Id convertTextIntoHtml() {
        String fileBody = queryFileFromStaticResource(fileNameInStaticResource);
        String[] rowValues = new String[]{};
            rowValues = fileBody.split('`"');
        
        String convertedHtmlRows = '';
        for (String rowValue : rowValues) {
            if (!String.isBlank(rowValue)) {
                convertedHtmlRows += (getConvertedTextValueIntoHtml(rowValue.trim()) + '\n');
            }
        }
        Id attId = createAttachment(convertedHtmlRows);
        return attId;
    }
    
    public String queryFileFromStaticResource(String fileName) {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name =:fileNameInStaticResource LIMIT 1];
        HttpRequest tmp = new HttpRequest();
        tmp.setBodyAsBlob(sr.Body);
        String body = tmp.getBody();
        return body;
    }
    
    public String getConvertedTextValueIntoHtml(String rowValue) {
        if (rowValue.indexOf('\n') == 2) {
            rowValue = rowValue.substring(2);
        }
        rowValue = (rowValue.replaceAll('\n', '<br>') + '"');
        rowValue = (rowValue.replaceAll('\\{\\{\\{Case.Running_User_Name}}}', '<br>\\{\\{\\{Case.Running_User_Name}}}'));
        return rowValue;
    }
    
    public Id createAttachment(String htmlValue) {
        Attachment att=new Attachment();
        att.Body=Blob.valueOf(htmlValue);
        att.Name='HtmlValueForEmailTemplate_.csv';
        att.parentId=this.parentId;
        insert att;
        return att.Id;
    }
}