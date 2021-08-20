### Contributing
## Overview
If you like the extension (I hope you do) and would like to contribute by adding new tables to it you can create a pull request to GitHub repository. 

To extend the solution with any new table you need to do 3 things.

## Add new Enum Value
Enum **MNB Tables To Translate** contains all tables with supported translations. Important is that the **value should have the same number as the table in the database**. For example, the Payment Terms table has number 3 and the Item table has 27.
![Add Enum Value](http://www.mynavblog.com/wp-content/uploads/2021/05/enum_extension.png)

## Add Codeunit that implements MNB ITranslation interface
In the codeunit, you need to specify which table is responsible for translations (for example Payment Method Translation stores all translations for Payment Methods) and which field is key (for example Payment Method Code field), and the text field that stores translation (for example Description field).
![Codeunit](http://www.mynavblog.com/wp-content/uploads/2021/05/codeunit_1-1024x724.png)

## Add Page Extension with Action
The action Translate should be visible on the page from which you will do the translation. You can copy one of the existing page extensions. Another option is just to add the action that will run the **TranslateSelectedRecords** procedure from codeunit **MNB Translation Mgt.**
![Page Action](http://www.mynavblog.com/wp-content/uploads/2021/05/page_extension_1.png)
