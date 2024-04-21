<script>
    export let title = "";
    export let description = "";
    export let keywords = "";
    export let image = "";
    export let url = "";
    export let type = "website";
    export let locale = "en_US";
    export let twitterCard = "summary_large_image";
    export let twitterHandle = "";
</script>

<svelte:head>
    <title>{title}</title>
    <meta name="description" content={description} />
    <meta name="keywords" content={keywords} />
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="og:image" content={image} />
    <meta property="og:url" content={url} />
    <meta property="og:type" content={type} />
    <meta property="og:locale" content={locale} />
    <meta name="twitter:card" content={twitterCard} />
    <meta name="twitter:image" content={image} />
    <meta name="twitter:site" content={twitterHandle} />
    <meta name="twitter:title" content={title} />
    <link rel="canonical" href={url} />
</svelte:head>