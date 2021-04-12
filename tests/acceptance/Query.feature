Feature: Query
  In order to use Doctrine ODM Query safely
  As a Psalm user
  I need Psalm to typecheck QueryBuilder

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm errorLevel="4">
        <projectFiles>
          <directory name="."/>
        </projectFiles>
        <plugins>
          <pluginClass class="RunToTheFather\DoctrineMongoDbPsalmPlugin\Plugin" />
        </plugins>
      </psalm>
      """
    And I have the following code preamble
      """
      <?php
        use Doctrine\ODM\MongoDB\DocumentManager;

        interface I {
          /** @return void */
          public function doThings();
        }

        /**
         * @return DocumentManager
         * @psalm-suppress InvalidReturnType
         */
        function documentManager() {}

        /** @return void */
        function acceptsI(I $i) {}
      """

  @Query::getSingleResult
  Scenario: getSingleResult returns expected object
    Given I have the following code
      """
      $qb = documentManager()->createQueryBuilder(I::class);
      $i = $qb->getQuery()->getSingleResult();

      if (null !== $i) {
        $i->doThings();
        acceptsI($i);
      }
      """
    When I run Psalm
    Then I see no errors

  @Query::errorsGetSingleResult
  Scenario: See errors without plugin
    Given I have the following code
      """
      $qb = documentManager()->createQueryBuilder(I::class);
      $i = $qb->getQuery()->getSingleResult();

      if (null !== $i) {
        $i->doThings();
        acceptsI($i);
      }
      """
    And I have the following config
      """
      <?xml version="1.0"?>
      <psalm errorLevel="4">
        <projectFiles>
          <directory name="."/>
        </projectFiles>
      </psalm>
      """
    When I run Psalm
    Then I see these errors
      | Type            | Message                                                                    |
      | InvalidArgument | Argument 1 of acceptsI expects I, array<array-key, mixed>\|object provided |
    And I see no other errors