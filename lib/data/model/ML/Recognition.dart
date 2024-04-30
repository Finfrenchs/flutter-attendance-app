import 'dart:ui';

class Recognition {
  String name;
  Rect location;
  List<double> embeddings;
  double distance;

  /// Constructs a Category.
  Recognition(
    this.name,
    this.location,
    this.embeddings,
    this.distance,
  );
}

class RecognitionEmbedding {
  
  Rect location;
  List<double> embeddings;
  

  /// Constructs a Category.
  RecognitionEmbedding(
    
    this.location,
    this.embeddings,
    
  );
}
