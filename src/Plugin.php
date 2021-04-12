<?php

namespace RunToTheFather\DoctrineMongoDbPsalmPlugin;

use Psalm\Plugin\PluginEntryPointInterface;
use Psalm\Plugin\RegistrationInterface;
use SimpleXMLElement;

class Plugin implements PluginEntryPointInterface
{
    public function __invoke(RegistrationInterface $psalm, ?SimpleXMLElement $config = null): void
    {
        $stubs = $this->getStubFiles();

        foreach ($stubs as $file) {
            $psalm->addStubFile($file);
        }
    }

    /** @return string[] */
    private function getStubFiles(): array
    {
        $files = array_merge(
            glob(__DIR__ . '/../stubs/*.phpstub') ?: [],
        );

        return $files;
    }
}