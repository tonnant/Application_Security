from xml.etree import ElementTree
tree = ElementTree.parse("openemrAppScan.xml")
for issue in tree.findall("//Issue"):
    type = issue.attrib['IssueTypeID']
    url = issue.findtext("Url","")

    v = issue.find("Variant")
    if v is not None:
        reas = v.findtext("Reasoning","")
        reas = reas.replace(',','#COMMA#')
        str = v.findtext("Difference", "")
        str = str.replace(',','#COMMA#')

    print url +  "," + type + "," + reas + "," + str

