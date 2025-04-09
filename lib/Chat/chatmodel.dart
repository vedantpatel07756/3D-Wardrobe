class ChatModel {
    String role;
    List<Part> parts;

    ChatModel({
        required this.role,
        required this.parts,
    });

}

class Part {
    FileData? fileData;
    String? text;

    Part({
        this.fileData,
        this.text,
    });

}

class FileData {
    String fileUri;
    String mimeType;

    FileData({
        required this.fileUri,
        required this.mimeType,
    });

}