package br.com.williamfranco.poke_app

import android.os.Bundle
import android.util.Log
import com.google.firebase.analytics.FirebaseAnalytics
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val TAG = "PokedexAnalytics"
        private const val CHANNEL = "com.pokedex.analytics/native"

        // Event Names
        private const val EVENT_POKEMON_VIEW = "pokemon_view"
        private const val EVENT_POKEMON_LIST_LOADED = "pokemon_list_loaded"
        private const val EVENT_POKEMON_LOAD_ERROR = "pokemon_load_error"
        private const val EVENT_SEARCH = "search"
        private const val EVENT_FILTER_APPLIED = "filter_applied"
        private const val EVENT_FILTERS_CLEARED = "filters_cleared"
        private const val EVENT_POKEMON_SORTED = "pokemon_sorted"
        private const val EVENT_EVOLUTION_VIEWED = "evolution_viewed"
        private const val EVENT_APP_ERROR = "app_error"

        // Parameter Keys
        private const val PARAM_POKEMON_ID = "pokemon_id"
        private const val PARAM_POKEMON_NAME = "pokemon_name"
        private const val PARAM_POKEMON_TYPE = "pokemon_type"
        private const val PARAM_COUNT = "count"
        private const val PARAM_ERROR_MESSAGE = "error_message"
        private const val PARAM_ERROR_CODE = "error_code"
        private const val PARAM_SEARCH_TERM = "search_term"
        private const val PARAM_RESULTS_COUNT = "results_count"
        private const val PARAM_FILTER_TYPE = "filter_type"
        private const val PARAM_FILTER_VALUE = "filter_value"
        private const val PARAM_SORT_TYPE = "sort_type"
        private const val PARAM_FROM_POKEMON = "from_pokemon"
        private const val PARAM_TO_POKEMON = "to_pokemon"
        private const val PARAM_DETAILS = "details"

        // Error Codes
        private const val ERROR_INVALID_ARGUMENT = "INVALID_ARGUMENT"
        private const val ERROR_ANALYTICS_ERROR = "ANALYTICS_ERROR"
    }

    private lateinit var firebaseAnalytics: FirebaseAnalytics
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initializeFirebaseAnalytics()
    }

    private fun initializeFirebaseAnalytics() {
        try {
            firebaseAnalytics = FirebaseAnalytics.getInstance(this)
            firebaseAnalytics.setAnalyticsCollectionEnabled(true)
            Log.d(TAG, "✅ Firebase Analytics initialized successfully")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to initialize Firebase Analytics: ${e.message}", e)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupMethodChannel(flutterEngine)
    }

    private fun setupMethodChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        methodChannel?.setMethodCallHandler { call, result ->
            try {
                Log.d(TAG, "➡️ Received method call: ${call.method}")

                when (call.method) {
                    "logEvent" -> handleLogEvent(call, result)
                    "logScreenView" -> handleLogScreenView(call, result)
                    "setUserId" -> handleSetUserId(call, result)
                    "setUserProperty" -> handleSetUserProperty(call, result)
                    "logPokemonView" -> handleLogPokemonView(call, result)
                    "logSearch" -> handleLogSearch(call, result)
                    "logFilter" -> handleLogFilter(call, result)
                    "setAnalyticsEnabled" -> handleSetAnalyticsEnabled(call, result)
                    else -> {
                        Log.w(TAG, "⚠️ Method not implemented: ${call.method}")
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error processing method call: ${e.message}", e)
                result.error(
                    ERROR_ANALYTICS_ERROR,
                    "Error processing analytics: ${e.message}",
                    e.stackTraceToString()
                )
            }
        }

        Log.d(TAG, "✅ MethodChannel configured: $CHANNEL")
    }

    override fun onDestroy() {
        super.onDestroy()
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        Log.d(TAG, "🧹 MethodChannel cleaned up")
    }

    // ==================== Handler Methods ====================

    private fun handleLogEvent(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val eventName = call.argument<String>("eventName")
        val parameters = call.argument<Map<String, Any>>("parameters")

        if (eventName.isNullOrBlank()) {
            result.error(ERROR_INVALID_ARGUMENT, "Event name is required", null)
            return
        }

        logEvent(eventName, parameters)
        result.success("Event '$eventName' logged successfully")
    }

    private fun handleLogScreenView(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val screenName = call.argument<String>("screenName")
        val screenClass = call.argument<String>("screenClass")

        if (screenName.isNullOrBlank()) {
            result.error(ERROR_INVALID_ARGUMENT, "Screen name is required", null)
            return
        }

        logScreenView(screenName, screenClass)
        result.success("Screen view '$screenName' logged successfully")
    }

    private fun handleSetUserId(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val userId = call.argument<String>("userId")

        if (userId.isNullOrBlank()) {
            result.error(ERROR_INVALID_ARGUMENT, "User ID is required", null)
            return
        }

        setUserId(userId)
        result.success("User ID set successfully")
    }

    private fun handleSetUserProperty(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val name = call.argument<String>("name")
        val value = call.argument<String>("value")

        if (name.isNullOrBlank() || value.isNullOrBlank()) {
            result.error(ERROR_INVALID_ARGUMENT, "Name and value are required", null)
            return
        }

        setUserProperty(name, value)
        result.success("User property '$name' set successfully")
    }

    private fun handleLogPokemonView(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val pokemonId = call.argument<Int>("pokemonId")
        val pokemonName = call.argument<String>("pokemonName")
        val pokemonType = call.argument<String>("pokemonType")

        if (pokemonId == null || pokemonName.isNullOrBlank()) {
            result.error(ERROR_INVALID_ARGUMENT, "Pokemon ID and name are required", null)
            return
        }

        logPokemonView(pokemonId, pokemonName, pokemonType)
        result.success("Pokemon view for '$pokemonName' logged successfully")
    }

    private fun handleLogSearch(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val searchTerm = call.argument<String>("searchTerm")
        val resultsCount = call.argument<Int>("resultsCount") ?: 0

        if (searchTerm.isNullOrBlank()) {
            result.error(ERROR_INVALID_ARGUMENT, "Search term is required", null)
            return
        }

        logSearch(searchTerm, resultsCount)
        result.success("Search for '$searchTerm' logged successfully")
    }

    private fun handleLogFilter(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val filterType = call.argument<String>("filterType")
        val filterValue = call.argument<String>("filterValue")

        if (filterType.isNullOrBlank() || filterValue.isNullOrBlank()) {
            result.error(ERROR_INVALID_ARGUMENT, "Filter type and value are required", null)
            return
        }

        logFilter(filterType, filterValue)
        result.success("Filter '$filterType: $filterValue' logged successfully")
    }

    private fun handleSetAnalyticsEnabled(
        call: io.flutter.plugin.common.MethodCall,
        result: MethodChannel.Result
    ) {
        val enabled = call.argument<Boolean>("enabled")

        if (enabled == null) {
            result.error(ERROR_INVALID_ARGUMENT, "Enabled flag is required", null)
            return
        }

        setAnalyticsEnabled(enabled)
        result.success("Analytics collection ${if (enabled) "enabled" else "disabled"}")
    }

    // ==================== Firebase Analytics Core Methods (SEM KTX) ====================

    private fun logEvent(eventName: String, parameters: Map<String, Any>?) {
        try {
            val bundle = Bundle()
            parameters?.forEach { (key, value) ->
                when (value) {
                    is String -> bundle.putString(key, value)
                    is Int -> bundle.putLong(key, value.toLong())
                    is Long -> bundle.putLong(key, value)
                    is Double -> bundle.putDouble(key, value)
                    is Boolean -> bundle.putLong(key, if (value) 1L else 0L)
                    is Float -> bundle.putDouble(key, value.toDouble())
                    else -> bundle.putString(key, value.toString())
                }
            }
            firebaseAnalytics.logEvent(eventName, bundle)
            Log.d(TAG, "✅ Event logged: $eventName | Params: $parameters")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to log event '$eventName': ${e.message}", e)
        }
    }

    private fun logScreenView(screenName: String, screenClass: String?) {
        try {
            val bundle = Bundle()
            bundle.putString(FirebaseAnalytics.Param.SCREEN_NAME, screenName)
            bundle.putString(FirebaseAnalytics.Param.SCREEN_CLASS, screenClass ?: "MainActivity")
            firebaseAnalytics.logEvent(FirebaseAnalytics.Event.SCREEN_VIEW, bundle)
            Log.d(TAG, "✅ Screen view logged: $screenName | Class: ${screenClass ?: "MainActivity"}")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to log screen view '$screenName': ${e.message}", e)
        }
    }

    private fun setUserId(userId: String) {
        try {
            firebaseAnalytics.setUserId(userId)
            Log.d(TAG, "✅ User ID set: $userId")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to set user ID: ${e.message}", e)
        }
    }

    private fun setUserProperty(name: String, value: String) {
        try {
            firebaseAnalytics.setUserProperty(name, value)
            Log.d(TAG, "✅ User property set: $name = $value")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to set user property '$name': ${e.message}", e)
        }
    }

    private fun setAnalyticsEnabled(enabled: Boolean) {
        try {
            firebaseAnalytics.setAnalyticsCollectionEnabled(enabled)
            Log.d(TAG, "✅ Analytics collection ${if (enabled) "enabled" else "disabled"}")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to set analytics enabled state: ${e.message}", e)
        }
    }

    // ==================== Pokédex Specific Analytics Methods ====================

    private fun logPokemonView(pokemonId: Int, pokemonName: String, pokemonType: String?) {
        try {
            val bundle = Bundle()
            bundle.putLong(PARAM_POKEMON_ID, pokemonId.toLong())
            bundle.putString(PARAM_POKEMON_NAME, pokemonName)
            pokemonType?.let { bundle.putString(PARAM_POKEMON_TYPE, it) }
            firebaseAnalytics.logEvent(EVENT_POKEMON_VIEW, bundle)
            Log.d(TAG, "✅ Pokemon view: $pokemonName (#$pokemonId) | Type: ${pokemonType ?: "N/A"}")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to log pokemon view: ${e.message}", e)
        }
    }

    private fun logSearch(searchTerm: String, resultsCount: Int) {
        try {
            val bundle = Bundle()
            bundle.putString(FirebaseAnalytics.Param.SEARCH_TERM, searchTerm)
            bundle.putLong(PARAM_RESULTS_COUNT, resultsCount.toLong())
            firebaseAnalytics.logEvent(FirebaseAnalytics.Event.SEARCH, bundle)
            Log.d(TAG, "✅ Search: '$searchTerm' | Results: $resultsCount")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to log search: ${e.message}", e)
        }
    }

    private fun logFilter(filterType: String, filterValue: String) {
        try {
            val bundle = Bundle()
            bundle.putString(PARAM_FILTER_TYPE, filterType)
            bundle.putString(PARAM_FILTER_VALUE, filterValue)
            firebaseAnalytics.logEvent(EVENT_FILTER_APPLIED, bundle)
            Log.d(TAG, "✅ Filter applied: $filterType = $filterValue")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to log filter: ${e.message}", e)
        }
    }
}
