using System;

using System.IO;

using UnityEngine;

using UnityEditor;

 

public class ModelAssetPostprocessor : AssetPostprocessor

{

    private const string PREFAB_DESTINATION_DIRECTORY = "Assets/Prefabs/";

 

    private static void OnPostprocessAllAssets(

        string[] importedAssets,

        string[] deletedAssets, string[]

        movedAssets, string[]

        movedFromAssetPaths )

    {

        foreach( string path in importedAssets )

        {

            if( !path.EndsWith( ".fbx", StringComparison.OrdinalIgnoreCase ) )

                continue;

 

            GameObject modelAsset = AssetDatabase.LoadAssetAtPath<GameObject>( path );

 

            CreatePrefabFromModel( path, modelAsset );

        }

    }

 

    private static void CreatePrefabFromModel( string path, GameObject modelAsset )

    {

        EnsureDirectoryExists( PREFAB_DESTINATION_DIRECTORY );

 

        string modelFileName = Path.GetFileNameWithoutExtension( path );

        string destinationPath = PREFAB_DESTINATION_DIRECTORY + modelFileName + ".prefab";

 

        if( File.Exists( destinationPath ) )

            return;

 

        GameObject prefab = new GameObject( modelAsset.name );

        GameObject model = InstantiateModelForEditing( modelAsset );

        model.transform.SetParent( prefab.transform );

 

        PrefabUtility.CreatePrefab( destinationPath, prefab, ReplacePrefabOptions.ConnectToPrefab );

 

        GameObject.DestroyImmediate( prefab );

    }

 

    private static void EnsureDirectoryExists( string directory )

    {

        if( !Directory.Exists( directory ) )

            Directory.CreateDirectory( directory );

    }

 

    private static GameObject InstantiateModelForEditing( GameObject model )

    {

        GameObject instance = GameObject.Instantiate( model );

        instance.name = model.name;

        return instance;

    }

}