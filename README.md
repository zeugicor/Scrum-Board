# web-2-scrum-app
======================
NodeJS Applikation mit einer Vielzahl von bereits konfigurierten Elementen. Unter anderem
wird **MongoDB** als Datenbank, **CoffeeScript** als JavaScript Precompiler, **Less** und
**Stylus** direkt unterstützt.
Die JavaScript Bibliothek **UnderscoreJS** steht sowohl server- als auch clientseitig zur Verfügung.


## Installation
----------------------
1.  Packet mit *git clone <Pfad zum Git Repository>* klonen
2.  In entsprechendes Verzeichnis wechseln
3.  *npm install*: Installation der benötigten Node Module
4.  *bower install*: Installation der benötigten clientseitigen Dependencies


## Server
----------------------
### Development
**node server** im entsprechenden Verzeichnis ausführen.

### Production
**forever start server** im entsprechenden Verzeichnis ausführen.

## Sockets
Generell sind die Socket Messages der Applikation wiefolgt aufgebaut:

	{
		"route": "unique.identification.for.type.of.request",
		"data": {
			"label": "contains data as object or as array of objects"
		},
		"error": true / false
	}


- **register:** Als neuer Benutzer für die Socket Broadcasts registrieren.
- **chat.messages.index**
- **chat.messages.show**
- **chat.messages.create**
- **users.index**