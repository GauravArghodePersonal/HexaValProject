public with sharing class CF_NamespaceUtils {

    private static final String MY_NAMESPACE = [ SELECT NamespacePrefix FROM ApexClass WHERE Name = 'CF_NamespaceUtils' LIMIT 1 ].NamespacePrefix;

    public static final String NAMESPACE = String.isBlank( MY_NAMESPACE ) ? '' : MY_NAMESPACE;

    public static final String NAMESPACE_API = String.isBlank( MY_NAMESPACE ) ? '' : MY_NAMESPACE + '__';

}