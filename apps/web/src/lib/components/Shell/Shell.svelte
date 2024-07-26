<div class="flex flex-col w-screen h-screen overflow-hidden">
	<slot name="top" />
	<main class="flex-grow -my-3 py-6 lg:py-8 px-3 lg:px-0 lg:mx-auto lg:w-3/4 overflow-x-hidden overflow-y-auto relative">
		<slot name="body" />
	</main>
	<slot name="bottom" />
</div>