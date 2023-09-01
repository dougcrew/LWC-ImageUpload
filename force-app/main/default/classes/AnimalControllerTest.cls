@isTest
public class AnimalControllerTest {
  @isTest
  static void testGetAnimal() {
    // Create a test Animal record
    Animal__c testAnimal = new Animal__c(Animal_Name__c = 'Test Animal');
    insert testAnimal;

    // Call the getAnimal() method with the test Animal record ID
    Animal__c result = AnimalController.getAnimal(testAnimal.Id);

    // Verify that the method returns the correct Animal record
    System.assertEquals(testAnimal.Id, result.Id,'Animal ID is wrong');
    System.assertEquals(testAnimal.Animal_Name__c, result.Animal_Name__c, 'Animal Name is wrong');
  }

  @isTest
  static void testGetAttachment() {
    // Create a test parent record
    Animal__c testAnimal = new Animal__c(Animal_Name__c = 'Test Animal');
    insert testAnimal;

    // Create a test attachment
    ContentVersion testAttachment = new ContentVersion(
      Title = 'Test Attachment',
      PathOnClient = 'test.txt',
      VersionData = Blob.valueOf('Test Attachment Data')
    );
    insert testAttachment;

    //Query for the ContentDocumentId of the ContentVersion record
    testAttachment = [
      SELECT ContentDocumentId
      FROM ContentVersion
      WHERE Id = :testAttachment.Id
    ];

    System.debug('ContentVersion record: ' + testAttachment);

    // Create a test content document link
    ContentDocumentLink testLink = new ContentDocumentLink(
      LinkedEntityId = testAnimal.Id,
      ContentDocumentId = testAttachment.ContentDocumentId,
      ShareType = 'V'
    );

    System.debug('ContentDocumentLIn record: ' + testLink);

    insert testLink;

    // Call the getAttachment() method with the test parent record ID
    Id result = AnimalController.getAttachment(testAnimal.Id);

    // Verify that the method returns the correct attachment ID
    System.assertEquals(testAttachment.Id, result, 'Incorrect attachment ID');
  }
}
