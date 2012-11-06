from xml.etree import ElementTree
tree = ElementTree.parse("try5.xml")
for issue in tree.findall("//Issue"):
    absl = issue.findtext("Abstract","")
    absl = absl.replace(',',' ')

    fname = ""
    line = ""

    p = issue.find("Primary")
    if p is not None:
        fname = p.findtext("FileName", "")
        line = p.findtext("LineStart", "")
    print fname + "," + line + "," + absl

