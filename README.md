# Translations
## Overview
Translations is the open source extension for Business Central. It allows to translate various records in Business Central automatically using Azure Cognitive Services.

### Supported Records
Translation for below records is supported:

1. Items
2. Item Attributes 
3. Item Attributes Values
4. Payment Terms
5. Payment Methods
6. Shipment Methods
7. Unit of Measure
8. Reminder Terms

## Install
You can take the app file directly from the repostitory. Also you can clone the repository to the VS Code and create your own package.

## Setup
### Translation Setup
In the **Azure Portal** first cognitive services and then install the Translator app.
![Azure Portal Setup](http://www.mynavblog.com/wp-content/uploads/2021/05/azure_portal_1.png)

Fill in all necessary data and create the app. After installation, open it and go to **Keys and Endpoints**. 
![Azure Portal Setup](http://www.mynavblog.com/wp-content/uploads/2021/05/setup_azure.png)

Those are values that you need to set in Business Central on Page **Translation Setup**.
1. Set **Key 1** value into field **Subscription Key**
2. Set **Location/Region** value into field **Subcription Region**
3. Set **Text Transation** value into field **Endpoint**

### Language Mapping
To create language mapping on the **Translation Setup** page open **Language Mapping** and then use the action ***Get Language Mapping***. It will create a mapping for you, but you always can insert manually, delete or correct the mapping if needed.

![Business Central Setup](http://www.mynavblog.com/wp-content/uploads/2021/05/language_mapping_1.png)

![Business Central Setup](http://www.mynavblog.com/wp-content/uploads/2021/05/language_mapping_2.png)

## Usage
Open one of the supported pages (for example Payment Terms), mark all records that you want to translate (you can mark many records), and run action **Translate**.
![Usage](http://www.mynavblog.com/wp-content/uploads/2021/05/translate_1.png)

You will see the list of available languages. You can mark any number of languages.
![Usage](http://www.mynavblog.com/wp-content/uploads/2021/05/translate_2.png)

If any translation already exists in Business Central, it will be skipped - the existing translation will not be overwritten.
![Result](http://www.mynavblog.com/wp-content/uploads/2021/05/translate_3.png)

![Result](http://www.mynavblog.com/wp-content/uploads/2021/05/translation_result.png)
