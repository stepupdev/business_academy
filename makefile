run_dev:
	flutter run --dart-define-from-file=config/config.dev.json

run_prod:
	flutter run --dart-define-from-file=config/config.prod.json

build_dev:
	flutter build apk --dart-define-from-file=config/config.dev.json
build_prod:
	flutter build apk --dart-define-from-file=config/config.prod.json

build_aab:
	flutter build appbundle --dart-define-from-file=config/config.prod.json

