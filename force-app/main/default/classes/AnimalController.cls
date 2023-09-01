public with sharing class AnimalController {
  // called to return record Name field
  @AuraEnabled(cacheable=true)
  public static Animal__c getAnimal(Id animalId) {
    return [
      SELECT Id, Animal_Name__c
      FROM Animal__c
      WHERE Id = :animalId
      WITH USER_MODE
    ];
  }
  @AuraEnabled(cacheable=true)
  public static Id getAttachment(Id parentId) {
    List<ContentDocumentLink> documentLinks = [
      SELECT ContentDocumentId
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :parentId
      WITH USER_MODE
      LIMIT 1
    ];

    if (documentLinks.size() > 0) {
      List<ContentVersion> contentVersions = [
        SELECT Id, ContentDocumentId, FileType, Title
        FROM ContentVersion
        WHERE ContentDocumentId = :documentLinks[0].ContentDocumentId
        WITH USER_MODE
        LIMIT 1
      ];

      if (contentVersions.size() > 0) {
        return contentVersions[0].Id;
      }
    }
    return null;
  }
}

// public with sharing class AnimalController {
//     @AuraEnabled
//     public static Id saveAttachment(
//       Id parentId,
//       String fileName,
//       String contentType,
//       String base64Data
// ) {
//   Attachment attachment = new Attachment();
//   attachment.ParentId = parentId;
//   attachment.Name = fileName;
//   attachment.ContentType = contentType;
//   attachment.Body = EncodingUtil.base64Decode(base64Data);
//   insert attachment;
//   return attachment.Id;
// }
// @AuraEnabled(cacheable=true)
// public static Attachment getAttachment(Id parentId) {
//   List<Attachment> attachments = [
//     SELECT Id, ParentId
//     FROM Attachment
//     WHERE ParentId = :parentId
//     LIMIT 1
//     ];
//   if (attachments.size() > 0) {
//     return attachments[0];
//   } else {
//     return null;
//   }
// }
// @AuraEnabled(cacheable=true)
// public static Animal__c getAnimal(Id animalId) {
//   return [SELECT Id, Name FROM Animal__c WHERE Id = :animalId];
// }

