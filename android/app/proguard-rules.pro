# google_mlkit_text_recognition references every script's recognizer, but
# Grimstock only bundles the Latin one, so R8 must not fail on the others.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
