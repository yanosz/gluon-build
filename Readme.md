Repository für Continiuous-Integration (CI) Builds
=================================================

Dieses Repository ermöglicht den wöchentlichen Gluon Build in der Gitlab CI.
Hierzu ist ein Makefile enthalten, dass alle hoods baut.

Die CI (.gitlab-ci.yml) kopiert die fertigen binaries dann auf https://kbu.freifunk.net/files/gluon-weekly/2016.2

Dieser Branch baut gluon Version 2016.2 - per default ist der no-autoupdate-Branch referenziert.

Der Build kann auch per Hand gestartert werden

* `make world` erstellt binaries für alle Hoods
* `make deploy` fügt die erstellte Firmware für alle Hoods zusätzlich in einer Deploy-Struktur zusammen.

