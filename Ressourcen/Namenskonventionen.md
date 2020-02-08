### Vorab lesen
[Azure Regeln](https://docs.microsoft.com/de-de/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)
___

### Allgemeine Richtlinien

* Bezeichnungen müssen in Kleinbuchstaben angegeben werden
* Leerzeichen und Sonderzeichen mit Ausnahme von Bindestrichen sind nicht erlaubt.
* die einzelnen Elemente eine Bezeichnung werden, wo möglich, mit einem Bindestrich getrennt (kebab-case).
* Jedes Segment sollte einen erkennbaren Namen oder eine Abkürzung in der jeweiligen Organisation haben.
* Wenn Parameter als optional markiert sind, müssen sie in der Hierarchie konsistent weitergeführt werden.

___

### Subscription

```html
<corporation>-<section>[-<productLine>]-sub[-<env>]
```

* **corporation:** Unternehmen.
* **section:** Abteilung, Team oder Produkt.
* **productLine:** *(optional)* Produktgruppierung oder Funktion.
* **environment:** *(optional)* prod/demo/test.

#### Beispiele

| Corporation | Section | Product Line | Environment | Name |
|--------------|-----------|--------------|-------------|------|
| Telehub AG | Infrastruktur | Virtuelle Arbeitsumgebung | Production | telag-infrastruktur-va-sub-prod |
| Krameek GmBH  | Controlling | n.v. | Production | kram-controlling-sub-prod |
| Invernia | Kundendienst | n.v. | Development | inver-kundendienst-sub-dev |
| Wunschpunsch | Shop | Web Services | n.v. | wp-shop-ws-sub |
| Wunschpunsch | Buchhaltung | Web Services | n.v. | wp-buchhaltung-ws-sub |
___

### Resource Group

```html
<corporation>-<product>-rg[-<env>][-<region>]
```

* **corporation:** Unternehmen.
* **product:** Produkt, Lösung, Service oder Plattform.
* **environment:** *(optional)* prod/demo/test.
* **region:** *(optional)* Azure Region. E.g. North Europe / West Europe.

#### Beispiele

| Corporation | Product | Environment | Region | Name |
|--------------|---------|-------------|--------|------|
| Telehub AG | Remote Desktop Services  | Development | North Europe | telag-remotedesktopservices-rg-dev-n-eu |
| Krameek GmBH | Gehaltsabrechnung | Production | North Europe | kram-gehaltsabrechnung-rg-prod-n-eu |
| Invernia | Ticketsystem | Production | West Europe | inver-ticketsystem-rg-prod-w-eu |
| Wunschpunsch | Newsletter | n.v. | North Europe | wp-newsletter-rg-n-eu |
| Wunschpunsch | Shopsystem | n.v. | North Europe | wp-shopsystem-rg-n-eu |

___

### Resource

```html
[<corporation>-]<product>-<resource>[-<identifier>][-<instance>][-<env>]
```

* **corporation:** *(optional)* Unternehmen.
* **product:** Produkt, Lösung, Service oder Plattform.
* **resource:** Bezeichnung der Resource in Azure.
* **identifier:** *(optional)* Name der Ressource.
* **instance:** *(optional)* prod/demo/test
* **env:** *(optional)* prod/demo/test

#### Beispiele

| Organisation | Product | Resource | Identifier | Instance | Environment | Name |
|--------------|---------|----------|------------|----------|-------------|------|
| Telehub AG | Remote Desktop Services  | Virtual machine | Domain Controller | n.v. | n.v. | telag-remotedesktopservices-vm-dc |
| Telehub AG | Remote Desktop Services  | Public IP | Domain Controller | n.v. | n.v.| telag-remotedesktopservices-pip-dc |
| Krameek GmBH | Gehaltsabrechnung | Web app | Datev App | n.v.| Production | kram-gehaltsabrechnung-app-datev-prod-n-eu |
| Krameek GmBH | Gehaltsabrechnung | App Service Plan | Datev App | n.v.| Production |  kram-gehaltsabrechnung-plan-datev-prod-n-eu |
| Invernia | Remote Desktop Services  | Virtual machine | Domain Controller | 001 | n.v.| telag-remotedesktopservices-vm-dc-001 |
| Invernia | Remote Desktop Services  | Virtual machine | Domain Controller | 002 | n.v.| telag-remotedesktopservices-vm-dc-002 |

___

## Beispiel


* **Subscription:** smea-connect-sub-dev
	* **Resource Group:** smea-apiv1-rg-dev-w-eu
		* **App Service Plan:** smea-apiv1-plan-001-dev
			* **Web App:** smea-apiv1-web-dev
		* **App Service Plan:** smea-apiv1-plan-002-dev
			* **Functions App:** smea-apiv1-func-dev
		* **Application Insights:** smea-apiv1-appi-dev
		* **Azure SQL Server:** smea-apiv1-sql-dev
		* **Azure SQL DB:** smea-apiv1-sqldb-dev
		* **Storage Account:** smeaconnectstordev

___


